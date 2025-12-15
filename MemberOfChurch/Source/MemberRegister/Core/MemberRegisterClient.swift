//
//  MemberRegisterClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/12/25.
//

import ComposableArchitecture
import SwiftUI

struct MemberRegisterClient {
    var churSectList: @Sendable () async -> AsyncStream<ChurchListEntity>
    
    var register: (_ params: [String: String],
                   _ imageData: Data?) async throws -> Data?
}

extension MemberRegisterClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            churSectList: {
                return AsyncStream<ChurchListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: AreaApi.churSectList.rawValue,
                                          completion: { (response: ChurchListEntity?) in
                        
                        if let response = response {
                            continuation.yield(response)
                            continuation.finish()
                        }
                    })
                }
            }, register: { params, imageData in
                // DEFAULT_URL + "process"
                guard let url =  URL(string: "https://www.goodnews.or.kr/chMember/mApi\(MemberRegisterApi.process.rawValue)") else { return nil }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.timeoutInterval = 30
                request.cachePolicy = .reloadIgnoringLocalCacheData
                
                // multipart
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let body = try makeMultipartBody(params: params,
                                                 imageData: imageData,
                                                 boundary: boundary,
                                                 fileField: "file",
                                                 filename: "image.jpg",
                                                 mime: "image/jpeg")
                request.httpBody = body
                request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
                
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                    throw URLError(.badServerResponse)
                }
//                let text = String.init(data: data, encoding: .utf8) ?? ""
//                print("result \(String.init(data: data, encoding: .utf8) ?? "")")
                return data
            }
        )
    }
}

extension MemberRegisterClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var memberRegisterClient: MemberRegisterClient {
        get { self[MemberRegisterClient.self] }
        set { self[MemberRegisterClient.self] = newValue }
    }
}

// MARK: - Helpers

private func makeMultipartBody(
    params: [String: String],
    imageData: Data?,
    boundary: String,
    fileField: String,
    filename: String,
    mime: String
) throws -> Data {
    var data = Data()
    let lineBreak = "\r\n"
    
    // params
    for (key, value) in params {
        data.append("--\(boundary)\(lineBreak)")
        data.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)")
        data.append("\(value)\(lineBreak)")
    }
    
    // file
    if let imageData {
        data.append("--\(boundary)\(lineBreak)")
        data.append("Content-Disposition: form-data; name=\"\(fileField)\"; filename=\"\(filename)\"\(lineBreak)")
        data.append("Content-Type: \(mime)\(lineBreak)\(lineBreak)")
        data.append(imageData)
        data.append(lineBreak)
    }
    
    data.append("--\(boundary)--\(lineBreak)")
    return data
}

private extension Data {
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8)!)
    }
}

