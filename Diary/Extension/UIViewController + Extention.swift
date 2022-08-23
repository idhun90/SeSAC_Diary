import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case presentFullScreen
        case push
    }
    
    func transition<T: UIViewController>(viewController: T, transitionStyle: TransitionStyle) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentFullScreen:
            let vc = viewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)

        }
    }
}
