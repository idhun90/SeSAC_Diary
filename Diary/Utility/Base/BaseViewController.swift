import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstaints()
    }
    
    func configure() { }
    func setConstaints() { }
}

extension UIViewController {
    
    func transitionViewController<T: UIViewController>(viewController vc: T) {
        
        let controller = vc
        self.present(controller, animated: true)
    }
}
