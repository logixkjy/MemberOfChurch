//
//  NetworkService.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/22/25.
//

import Foundation
import Alamofire
import Combine
import UIKit

fileprivate class NetworkConfig {
    lazy var header: HTTPHeaders = {
        let header: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" : "application/json"
        ]
        return header
    } ()
}

final class NetworkService {
    static let shared = NetworkService()
    
    func create<T: Decodable>(method: HTTPMethod,
                              apiURL: String,
                              completion: @escaping(T?) -> Void) {
        let urlString = "https://www.goodnews.or.kr/chMember/mApi\(apiURL)"
        
        if let url = URL(string: urlString) {
            print("📕 [NetworkService] URL - \(url)")
            
            AF.request(url,
                       method: method,
                       encoding: JSONEncoding.default
            ) {$0.timeoutInterval = 120}
                .validate()
                .responseDecodable(of: T.self) { response in 
                    switch response.result {
                    case .success:
                        print("📕[NetworkService] success - \(response)")
                        completion(response.value)
                        
                    case .failure(let error):
                        print("📕 [NetworkService] error - \(error)")
                    }
                }
        }
    }
    func create<T: Decodable>(method: HTTPMethod,
                              apiURL: String,
                              params: [String: Any] = [:],
                              imageData: Data? = nil,
                              completion: @escaping(T?) -> Void) {
        var tempParams = params
        let urlString = "https://www.goodnews.or.kr/chMember/mApi\(apiURL)"
        
        if let url = URL(string: urlString) {
            print("📕 [NetworkService] URL - \(url)")
            print("📕 [NetworkService] Params - \(String(describing: tempParams))")
            
            AF.request(url,
                       method: method,
                       parameters: tempParams,
                       encoding: JSONEncoding.default
            ) {$0.timeoutInterval = 120}
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success:
                        print("📕[NetworkService] success - \(response)")
                        completion(response.value)
                        
                    case .failure(let error):
                        print("📕 [NetworkService] error - \(error)")
                    }
                }
        }
    }
    
//    // 비동기 이미지
//    func asyncUploadImage(urlString: String, image: UIImage) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
//        
//        UtilEnvironment.isLoading += 1
//        
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data"
//        ]
//        
//        if let url = URL(string: urlString) {
//            AF.upload(imageData, to: url, method: .put, headers: headers)
//                .uploadProgress { progress in
//                    print("uploadImage Progress: \(progress.fractionCompleted)")
//                }
//                .response { response in
//                    switch response.result {
//                    case .success(_): print("uploadImage success : \(response)")
//                    case .failure(let error): print(error.errorDescription ?? "error")
//                    }
//                    
//                    if UtilEnvironment.isLoading > 0 {
//                        UtilEnvironment.isLoading -= 1
//                    }
//                }
//        }
//    }
    
//    // 동기 이미지
//    func syncUploadImage(urlString: String, image: UIImage, completion: @escaping(Bool) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
//        
//        UtilEnvironment.isLoading += 1
//        
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data"
//        ]
//        
//        if let url = URL(string: urlString) {
//            AF.upload(imageData, to: url, method: .put, headers: headers)
//                .uploadProgress { progress in
//                    print("uploadImage Progress: \(progress.fractionCompleted)")
//                }
//                .response { response in
//                    switch response.result {
//                    case .success(_):
//                        print("uploadImage success : \(response)")
//                        completion(true)
//                    case .failure(let error):
//                        print(error.errorDescription ?? "error")
//                        completion(false)
//                    }
//                    
//                    if UtilEnvironment.isLoading > 0 {
//                        UtilEnvironment.isLoading -= 1
//                    }
//                }
//        }
//    }
    
//    // 이미지 다운로드
//    func syncDownLoadImage(urlString: String) -> UIImage? {
//        var result: UIImage? = nil
//        
//        UtilEnvironment.isLoading += 1
//        
//        let url = "\(ConfigEnvironment.s3Url)\(urlString)"
//        
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        let queue = DispatchQueue.global(qos: .userInteractive)
//        AF.download(url).response(queue: queue) { response in
//            if response.error == nil, let imagePath = response.fileURL?.path {
//                if let image = UIImage(contentsOfFile: imagePath) {
//                    result = image
//                }
//            }
//            dispatchGroup.leave()
//        }
//        
//        dispatchGroup.wait()
//        
//        if UtilEnvironment.isLoading > 0 {
//            UtilEnvironment.isLoading -= 1
//        }
//        
//        return result
//    }
    
    
    
    
//    // 비동기 이미지
//    func asyncUploadFile(
//        urlString: String,
//        path: String,
//        completion: @escaping(Bool) -> Void
//    ) {
//        do {
//            let fileData = try Data(contentsOf: URL.init(filePath: path))
//            UtilEnvironment.isLoading += 1
//            
//            let headers: HTTPHeaders = [
//                "Content-type": "multipart/form-data"
//            ]
//            
//            if let url = URL(string: urlString) {
//                AF.upload(fileData, to: url, method: .put, headers: headers)
//                    .uploadProgress { progress in
//                        print("uploadImage Progress: \(progress.fractionCompleted)")
//                    }
//                    .response { response in
//                        switch response.result {
//                        case .success(_):
//                            print("uploadData success : \(response.response ?? HTTPURLResponse())")
//                        case .failure(let error):
//                            print(error.errorDescription ?? "error")
//                        }
//                        
//                        if UtilEnvironment.isLoading > 0 {
//                            UtilEnvironment.isLoading -= 1
//                        }
//                        completion(response.response?.statusCode == 200)
//                    }
//            }
//        } catch {
//            print("debugLog Data Load Failed!!! \(error.localizedDescription)")
//            return
//        }
//    }
}
