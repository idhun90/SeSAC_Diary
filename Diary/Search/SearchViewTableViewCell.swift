import UIKit

class SearchViewTableViewCell: BaseTableViewCell {
    
    let searchImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .systemGray
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .systemGray
        return view
    }()
    
    lazy var stactView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, contentLabel, dateLabel])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 1
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.backgroundColor = .systemBackground
        
        [searchImageView, stactView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstaints() {
        let spacing = 14
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView)
            $0.trailing.equalTo(self.contentView).inset(spacing)
            $0.height.equalTo(self.contentView.snp.height).multipliedBy(0.7)
            $0.width.equalTo(searchImageView.snp.height)
        }
        
        stactView.snp.makeConstraints {
            $0.leading.equalTo(self.contentView.snp.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(self.searchImageView.snp.leading).offset(-spacing)
            $0.top.bottom.equalTo(self.searchImageView)
        }
    }
}
