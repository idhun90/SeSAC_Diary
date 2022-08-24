import UIKit

import SnapKit

class BackupAndRestoreTableViewCell: BaseTableViewCell {
    
    let backupRestoreButton: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 17)
        view.textColor = .systemBlue
        view.textAlignment = .left
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.contentView.addSubview(backupRestoreButton)
    }
    
    override func setConstaints() {
        let spacing = 20
        backupRestoreButton.snp.makeConstraints {
            $0.top.bottom.equalTo(self.contentView)
            $0.leading.equalTo(self.contentView.snp.leading).offset(spacing)
            $0.trailing.lessThanOrEqualTo(self.contentView.snp.trailing).offset(-spacing)
        }
    }
    
    func setup(text: String) {
        self.backupRestoreButton.text = text
    }
    
    func startBackup() {
        print("백업 시작")
    }
    
    func startRestore() {
        print("복원 시작")
    }
}
