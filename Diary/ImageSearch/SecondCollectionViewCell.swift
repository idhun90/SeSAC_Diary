import UIKit

import SnapKit

class SecondCollectionViewCell: BaseCollectionViewCell {
    
    let searchedImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let selectedButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = nil
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "checkmark.circle.fill")
        configuration.buttonSize = .medium
        configuration.baseForegroundColor = .systemBlue
        configuration.baseBackgroundColor = .white
        
        let view = UIButton(configuration: configuration, primaryAction: nil)
        view.isHidden = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [searchedImageView, selectedButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstaints() {
        searchedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectedButton.snp.makeConstraints {
            let spacing = 8
            $0.trailing.equalTo(searchedImageView.snp.trailing).inset(spacing)
            $0.bottom.equalTo(searchedImageView.snp.bottom).inset(spacing)
            $0.width.height.equalTo(24)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            searchedImageView.alpha = isSelected ? 0.5 : 1.0
            selectedButton.isHidden = isSelected ? false : true
        }
    }
    
    // 재사용 문제 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        searchedImageView.image = nil
        isSelected = false
    }
    
    func roadData(data: UnsplashData) {
        guard let url = URL(string: data.regularImageUrl) else { return }
        searchedImageView.kf.setImage(with: url)
    }
    
}
