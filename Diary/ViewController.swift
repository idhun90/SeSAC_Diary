import UIKit
import Zip

// 08.25 백업, 복구
class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //        self.backupButtonClicked()
        }
        
        func backupButtonClicked() {
            
            var urlPaths = [URL]() // realm 경로 추가 배열 (백업할 파일의 경로)
            
            // 1. 도큐먼트 위치에 백업 파일 유무 확인
            // 위치 가져오기
            guard let path = documentDirectoryPath() else { // 도큐먼트 폴더 경로 가져오는 코드
                showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
                return
            }
            
            // default.realm 경로를 보여줌.
            // .path를 추가하면 스트링 타입으로 URL을 알 수 있다.
            // default.realm 파일은 도큐먼트 디렉토리에 realm 설치시 디폴트 네이밍 폴더
            // 백업할 위치에 해당 폴더 위치 정보 체크
            // appendingPathComponent는 슬러시이다.~~~~~~~~ "/"
            let realmFile = path.appendingPathComponent("default.realm") // realmFile이 없을 수 있다. 유효 여부 체크, 단순히 URL이다. 경로는 있지만 실제 파일이 없을 수 있음. 유효성 검사 필요
            
            // 해당 경로에 실제 파일이 있는지 체크
            guard FileManager.default.fileExists(atPath: realmFile.path) else {
                showAlertMessage(title: "백업할 파일이 없습니다.")
                return
            }
            
            urlPaths.append(URL(string: realmFile.path)!)
            
            // 2. 백업 파일이 있다면, 백업 파일을 압축 (백업파일의 URL 만들고, 압축 링크를 생성)
            // 백업 파일을 압축: URL, 오픈소스 Zip 활용
            do { //압축이 끝날 때까지 안전하게 되야 하기 때문에 do catch문
                let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSacDiary_1") // urlPaths를 압축하겠다. 압축 파일 이름은 "SeSacDiaray_1"
                print("Archive Location: \(zipFilePath)")
                showActivityViewController() // 압축이 성공했을 때만 작동하게끔
                // 3. 압축이 완료되면, ActivityViewController 띄우기
                
            } catch {
                showAlertMessage(title: "압축을 실패했습니다.")
            }
            
        }
        
        func showActivityViewController() {
            
            guard let path = documentDirectoryPath() else { // 도큐먼트 폴더 경로 가져오는 코드
                showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
                return
            }
            
            let backupFileURL = path.appendingPathComponent("SeSacDiary_1.zip") // 별도의 경로를 가져올 때는 확장자까지 잘 명시해줘야함.
            
            let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: []) // 압축파일(새싹 다이어리 파일)을 내보내야 할 것 (activityItems), 두 번째 매개변수는 사용하지 않음. 일단 빈 배열 지정
            // 새싹 파일 경로를 전달해줘야 함.
            
            self.present(vc, animated: true)
            
        }
        
        func restoreButtonClicked() {
            
            // 파일앱 띄우기
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true) // 첫번째 매개변수: 해당 파일의 확장자만 선택할 수 있도록 뜸, 두번째 매개변수: 원본을 가져올 것인지, 복사본을 불러올것인지
            
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false // 여러 개 선택하지 못 하게 비활성화
            
            self.present(documentPicker, animated: true)
            
        }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    
    // 취소를 누른 경우
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    // 문서를 선택한 경우
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else { // 우리가 선택한 파일 앱 첫번째 url 예: fileapp/folder/~~~~~~
            showAlertMessage(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else { // 도큐먼트 폴더 경로 가져오는 코드
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent) // ~~~~~~.sesac 뒤에 있는 url 정보를 합침. //실제 파일이 들어온 건 아님 // 실제 파일이 들어갈 경로만 명시
        // 이미 저장이 되어 있는 경우 -> 파일 앱에서 경로를 가져올 필요 없음. (selectedFilURL)
        
        // 압축해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) { // 실제 파일이 존재한다면 이미 복구할 파일이 있는 것 -> 압축 풀어주면 됨
            
            let fileURL = path.appendingPathComponent("SeSacDiary_1.zip")
            
            do { // overwirte: 덮어씌워줄건지, progress: 압축 현황 체크
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                    // 루트뷰 변경해주는 코드로 하면 자동으로 인식
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        } else {
            
            // 경로에 파일이 없기 때문에, 파일앱에 있는 파일을 이동시켜야 한다
            do {
                // 파일 앱의 zip -> 도큐먼트 폴더로 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSacDiary_1.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}

