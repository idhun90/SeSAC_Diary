import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.borderStyle = .none
        self.backgroundColor = .systemBackground
        self.textAlignment = .center
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
