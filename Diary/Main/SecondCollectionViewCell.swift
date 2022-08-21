import UIKit

import SnapKit

class SecondCollectionViewCell: BaseViewCell {
    
    let searchedImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [searchedImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstaints() {
        searchedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // 재사용 문제 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        searchedImageView.image = nil
    }
    
    func roadData(data: UnsplashData) {
        guard let url = URL(string: data.regularImageUrl) else { return }
        searchedImageView.kf.setImage(with: url)
    }
    
}
