import UIKit

import SnapKit

class BackupHistoryTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .left
        
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 15)
        view.textColor = .systemGray
        view.textAlignment = .center

        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.accessoryType = .disclosureIndicator
        [titleLabel, dateLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
    
    
    override func setConstaints() {
        let spacing = 20
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(self.contentView)
            $0.leading.equalTo(self.contentView.snp.leading).offset(spacing)
            $0.trailing.lessThanOrEqualTo(self.dateLabel.snp.leading).offset(-(spacing / 2))
        }
        
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(self.contentView)
            $0.width.equalTo(spacing * 5)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-(spacing / 2))
        }
    }
}
