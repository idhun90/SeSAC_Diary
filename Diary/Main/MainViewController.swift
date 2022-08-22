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
 
            if let selectedImageUrl = vc.selectedImageUrl {
                let url = URL(string: selectedImageUrl)
                self.mainView.photoImageView.kf.setImage(with: url)
            } else {
                self.mainView.photoImageView.image = UIImage(systemName: "xmark")
            }
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        
        self.present(nvc, animated: true)
    }
}
