import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstaints()
    }
    
    func configure() { }
    func setConstaints() { }
    
    func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

