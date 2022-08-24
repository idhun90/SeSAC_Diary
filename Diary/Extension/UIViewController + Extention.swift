import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case presentFullScreen
        case push
    }
    
    enum UnwindStyle {
        case dismiss
        case pop
    }
    
    func transition<T: UIViewController>(viewController: T, transitionStyle: TransitionStyle) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentFullScreen:
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func unwind(unwindStyle: UnwindStyle) {
        
        switch unwindStyle {
        case .dismiss:
            self.dismiss(animated: true)
        case .pop:
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
