import UIKit

import Kingfisher

class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .systemBackground
    }
    
    override func configure() {
        mainView.choiceButton.addTarget(self, action: #selector(clickedChoiceButton), for: .touchUpInside)
    }
    
    @objc func clickedChoiceButton() {
        
        let vc = SecondViewController()
        vc.dataHandler = {
            let url = URL(string: vc.selectedImageUrl ?? "xmark")
            self.mainView.photoImageView.kf.setImage(with: url)
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        
        self.present(nvc, animated: true)
    }
}
