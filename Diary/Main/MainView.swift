import UIKit

import SnapKit

class MainView: BaseView {
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 4
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let titleTextField: CustomTextField = {
        let view = CustomTextField()
        view.placeholder = "제목을 입력해주세요."
        return view
    }()
    
    let dataTextField: CustomTextField = {
        let view = CustomTextField()
        view.placeholder = "날짜를 입력해주세요."
        return view
    }()
    
    let mainTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let choiceButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "선택"
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .systemBlue
        
        let view = UIButton(configuration: configuration, primaryAction: nil)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [photoImageView, titleTextField, dataTextField, mainTextView] .forEach {
            self.addSubview($0)
        }
        
        photoImageView.addSubview(choiceButton)
        
    }
    
    override func setConstaints() {
        
        photoImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(20)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(60)
        }
        
        dataTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(60)
        }
        
        mainTextView.snp.makeConstraints {
            $0.top.equalTo(dataTextField.snp.bottom).offset(20)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        choiceButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(photoImageView).inset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(44)
        }
    }
}
