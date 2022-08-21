import UIKit

import SnapKit

class SecondCollectionViewCell: BaseViewCell {
    
    let searchedImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
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
    
}
