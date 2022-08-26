import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 경로를 못 찾을 수 있으니 nil 반환
        return documentDirectory
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 도큐먼트 폴더 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이미지 저장 경로
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } // 원본이 아닌 압축 이미지가 필요할 때
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("파일 저장 실패", error)
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) { // 해당 경로에 실제 이미지 존재 유무 파악
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print("이미지 제거 실패", error)
        }
    }
    
    //0825
    // 테이블 뷰로 백업 리스트 보여주기
    func fetchDocumentZipFile() -> [String]? {
        
        do {
            guard let path = documentDirectoryPath() else { return nil }
            
            // 하위 폴더까지 가져올 수 있는 메소드 제공함
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil) // 무조건 전체 목록만 보여줌
            print("docs: \(docs)")
            
            // 압축만 보여줌
            let zip = docs.filter { $0.pathExtension/*확장자를 의미*/ == "zip" }
            print("zip: \(zip)")
            
            let backupData = zip.map { $0.lastPathComponent} // 디렉토리의 마지막 구성 요소 URL
            print("result: \(backupData)")
        
            // 백업 데이터가 여러개라면 날짜 순으로 정렬 후 반환 필요
            return backupData
            
        } catch {
            print("백업 리스트 확인 실패")
            return nil
        }
    }
}
