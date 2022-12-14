import UIKit

import SnapKit

class BackupAndRestoreView: BaseView {
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(BackupAndRestoreTableViewCell.self, forCellReuseIdentifier: BackupAndRestoreTableViewCell.reusebleIdentifier)
        view.register(BackupHistoryTableViewCell.self, forCellReuseIdentifier: BackupHistoryTableViewCell.reusebleIdentifier)
        return view
        
    }()
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.addSubview(tableView)
        self.backgroundColor = .systemGray6
    }
    
    override func setConstaints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
