import UIKit

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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationUI()
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
    }
    
    func navigationUI() {
        title = "설정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        self.unwind(unwindStyle: .dismiss)
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
            return 3 // 배열 카운트 차후 수정 필요
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == BackupAndRestore.backupAndRestore.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupAndRestoreTableViewCell.reusebleIdentifier, for: indexPath) as? BackupAndRestoreTableViewCell else { return UITableViewCell() }
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupHistoryTableViewCell.reusebleIdentifier, for: indexPath) as? BackupHistoryTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
