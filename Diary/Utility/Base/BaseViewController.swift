import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() { }
}

extension UIViewController {
    
    func transitionViewController<T: UIViewController>(storyboard: String, viewController vc: T) {
        
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: T.reusebleIdentifier) as? T else { return }
        
        self.present(controller, animated: true)
    }
}
