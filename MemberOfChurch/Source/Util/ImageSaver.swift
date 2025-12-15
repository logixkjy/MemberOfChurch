//
//  ImageSaver.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/21/25.
//

import UIKit

enum ImageSaveError: Error {
    case decodeFailed
}

struct ImageSaver {
    /// Obj‑C의 saveImageData: + resizeImage: 를 합친 버전
    /// - Returns: 저장된 최종 파일 URL (…/Documents/.data/Photo/photo_yyyyMMddHHmmssSSS.jpg)
    static func saveImageData(_ data: Data, maxLongSide: CGFloat = 800) throws -> URL {
        // 1) 디코드
        guard let ui = UIImage(data: data) else { throw ImageSaveError.decodeFailed }
        
        // 2) 회전 보정 + 리사이즈
        let fixed   = ui.fixedOrientation()
        let resized = fixed.resizedToFit(maxLongSide: maxLongSide)
        
        // 3) JPEG 0.9 (입력이 png/heic여도 최종은 .jpg)
        guard let jpeg = resized.jpegData(compressionQuality: 0.9) ?? ui.jpegData(compressionQuality: 0.9) else {
            throw ImageSaveError.decodeFailed
        }
        
        // 4) 경로 준비: Documents/.data/Photo/photo_yyyyMMddHHmmssSSS.jpg
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dir  = docs.appendingPathComponent(".data/Photo", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        
        let filename = "photo_\(Self.timestamp()).jpg"
        let fileURL  = dir.appendingPathComponent(filename)
        
        // 5) 쓰기(원자적)
        try jpeg.write(to: fileURL, options: .atomic)
        return fileURL
    }
    
    private static func timestamp() -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale   = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyyMMddHHmmssSSS"
        return f.string(from: Date())
    }
    
    static func saveImageDataAsync(_ data: Data, maxLongSide: CGFloat = 800) async throws -> URL {
        try await withCheckedThrowingContinuation { cont in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let url = try ImageSaver.saveImageData(data, maxLongSide: maxLongSide)
                    cont.resume(returning: url)
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
    }
}

private extension UIImage {
    /// Obj‑C `fixrotation:` 대응: 이미지 방향을 .up으로 고정
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        // 캔버스에 다시 그리기
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// 긴 변 기준으로 `maxLongSide`에 맞춰 리사이즈
    func resizedToFit(maxLongSide: CGFloat) -> UIImage {
        let w = size.width, h = size.height
        guard max(w, h) > maxLongSide, w > 0, h > 0 else { return self }
        
        let scale = (w > h) ? (maxLongSide / w) : (maxLongSide / h)
        let newSize = CGSize(width: floor(w * scale), height: floor(h * scale))
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
