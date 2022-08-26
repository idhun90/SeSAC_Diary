import UIKit

import SnapKit

class HomeTableViewCell: BaseTableViewCell {
    
    let homeImageView: UIImageView = {
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
        let view = UIStackView(arrangedSubviews: [titleLabel,contentLabel, dateLabel])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 1
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: USerDiary) {
        titleLabel.text = data.title
        dateLabel.text = data.date.formatted()
        contentLabel.text = data.content
        homeImageView.image = loadImageFromDocument(fileName: "\(data.objectId).jpg")
        
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 세부 경로 접근
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이미지를 저장할 위치
        
        if FileManager.default.fileExists(atPath: fileURL.path) { // 해당 경로에 실제 이미지 존재 유무 파악
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    
    override func configure() {
        self.backgroundColor = .systemBackground
        
        [homeImageView, stactView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstaints() {
        
        let spacing = 14
        
        homeImageView.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView)
            $0.trailing.equalTo(self.contentView).inset(spacing)
            $0.height.equalTo(self.contentView.snp.height).multipliedBy(0.7)
            $0.width.equalTo(homeImageView.snp.height)
        }
        
        stactView.snp.makeConstraints {
            $0.leading.equalTo(self.contentView.snp.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(self.homeImageView.snp.leading).offset(-spacing)
            $0.top.bottom.equalTo(self.homeImageView)
        }
    }
}
