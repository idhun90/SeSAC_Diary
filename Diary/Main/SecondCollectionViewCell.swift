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
    
    let selectedButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = nil
        configuration.cornerStyle = .capsule
        configuration.background.strokeColor = .white
        configuration.background.strokeWidth = 3
        configuration.baseBackgroundColor = .systemBlue
        
        let view = UIButton(configuration: configuration, primaryAction: nil)
        view.isHidden = true
        // 여기에 추가를 안 해주니 첫 로딩 때 버튼이 표기됨, 재사용 prepare에 nil 값을 줘도 왜 표기되지?
        // isSelected가 기본값이 false로 출력되는데 didset 구문은 초기화 시점에서 한 번 호출이 되면 false 값이라 버튼이 안 보이는 게 맞는 것 같은데 음
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(isSelected)
        
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
            $0.trailing.equalTo(searchedImageView.snp.trailing).inset(4)
            $0.bottom.equalTo(searchedImageView.snp.bottom).inset(4)
            $0.width.height.equalTo(20)
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
