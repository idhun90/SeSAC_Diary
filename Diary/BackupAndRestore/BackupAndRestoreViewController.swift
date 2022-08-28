import UIKit

import Zip

enum BackupAndRestore: Int, CaseIterable {
    case backupAndRestore
    case backupAndRestoreHistory
    
    var sectionTitle: String {
        switch self {
        case .backupAndRestore:
            return "백업 및 복원"
        case .backupAndRestoreHistory:
            return "백업 내역"
        }
    }
}

class BackupAndRestoreViewController: BaseViewController {
    
    let mainView = BackupAndRestoreView()
    
    let buttonTitleList = ["데이터 백업", "데이터 복원"]
    var backupData: [String] = []
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationUI()
        getBackupData()
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
    }
    
    func navigationUI() {
        //title = "설정2" // 네비게이션, 탭바 타이틀이 같은 값으로 설정된다.
        navigationItem.title = "설정"
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(cancelButtonClicked)) // 탭바 추가로 비활성화
    }
    
    //@objc func cancelButtonClicked() { // 탭바 추가로 비활성화
        //self.unwind(unwindStyle: .dismiss)
    //}
    
    func getBackupData() {
        guard let backup = fetchDocumentZipFile() else {
            print("백업 데이터가 존재하지 않습니다.")
            return
        }
        backupData = backup
        print(#function)
        print("백업 데이터 존재함: \(backupData)")
        print("==========================================")
        mainView.tableView.reloadSections(IndexSet(integer: BackupAndRestore.backupAndRestoreHistory.rawValue), with: .automatic)
    }
    
    // 백업 메소드
    func backupStart() {
        
        var urlPaths = [URL]() // 백업 파일 경로
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let realmFile = path.appendingPathComponent("default.realm")
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업할 파일이 없습니다.")
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!)
        
        // 백업 파일 압축
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSacDiary_1")
            print("압축 위치: \(zipFilePath)")
            showActivityViewController()
            
        } catch {
            showAlertMessage(title: "압축을 실패했습니다.")
        }
        // 새로운 백업 파일 생성 시 백업 리스트 및 백업 리스트 셀 갱신 필요
        getBackupData()
    }
    
    func showActivityViewController() {
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("SeSacDiary_1.zip")
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: nil)
        
        self.present(vc, animated: true)
    }
    
    func restoreStart() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker, animated: true)
    }
    
}

extension BackupAndRestoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BackupAndRestore.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case BackupAndRestore.backupAndRestore.rawValue:
            return BackupAndRestore.backupAndRestore.sectionTitle
        case BackupAndRestore.backupAndRestoreHistory.rawValue:
            return BackupAndRestore.backupAndRestoreHistory.sectionTitle
        default:
            return "기본"
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case BackupAndRestore.backupAndRestore.rawValue:
            return 2
        case BackupAndRestore.backupAndRestoreHistory.rawValue:
            return backupData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == BackupAndRestore.backupAndRestore.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupAndRestoreTableViewCell.reusebleIdentifier, for: indexPath) as? BackupAndRestoreTableViewCell else { return UITableViewCell() }
            
            cell.setup(text: buttonTitleList[indexPath.row])
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupHistoryTableViewCell.reusebleIdentifier, for: indexPath) as? BackupHistoryTableViewCell else { return UITableViewCell() }
            
            cell.setData(backupData[indexPath.row])

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == BackupAndRestore.backupAndRestore.rawValue {
            
            if indexPath.row == 0 {
                self.backupStart()
                
            } else {
                self.restoreStart()
            }
        } else {
            print("\(indexPath) 클릭 됨")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("\(indexPath.row) 삭제됨")
            
            // 백업 파일도 함께 제거 필요
            guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let backupFileURL = documentDirectoryURL.appendingPathComponent("SeSacDiary_1.zip")
            
            do {
                try FileManager.default.removeItem(at: backupFileURL)
                getBackupData() // 백업 리스트 배열, 백업 리스트 테이블뷰 셀 갱신 필요
                print("백업 파일 삭제됨")
            } catch let error {
                print("백업 파일 삭제 실패", error)
            }
            
        }
    }
    // 백업 내역 스와이프해서 내보내기 기능도 추가 가능할 듯
}

extension BackupAndRestoreViewController: UIDocumentPickerDelegate {
    
    // 취소 버튼 누를 시
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    // 문서 선택 시
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let fileURL = path.appendingPathComponent("SeSacDiary_1.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print(("unzippedFile: \(unzippedFile)"))
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSacDiary_1.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print(("unzippedFile: \(unzippedFile)"))
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}
