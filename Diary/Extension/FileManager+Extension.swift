import UIKit

extension UIViewController {
    
    // Document에서 이미지 가져오기
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 세부 경로 접근
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이미지를 저장할 위치
        
        if FileManager.default.fileExists(atPath: fileURL.path) { // 해당 경로에 실제 이미지 존재 유무 파악
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    
    // Document에서 이미지 삭제
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print("오류 발생", error)
        }
    }
    
    // Document에 이미지 저장
    // 싱글턴 패턴
    func saveImageToDocument(fileName: String, image: UIImage) {
        // Document 경로
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부 경로, 이미지 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } // 원본이 아닌 압축 이미지가 필요할 때
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("파일 저장 실패", error)
        }
    }
    
}
