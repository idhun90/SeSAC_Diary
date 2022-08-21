import UIKit

class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
    }
    
    override func configure() {
        mainView.choiceButton.addTarget(self, action: #selector(clickedChoiceButton), for: .touchUpInside)
    }
    
    @objc func clickedChoiceButton() {
        
        let vc = SecondViewController()
        
        //값 전달 코드 추가 필요
        
        let nvc = UINavigationController(rootViewController: vc)
        
        nvc.modalPresentationStyle = .fullScreen
        
        self.present(nvc, animated: true)
    }
}
