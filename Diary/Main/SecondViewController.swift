import UIKit

class SecondViewController: BaseViewController {
    
    var mainView = SecondView()
    //
    override func loadView() {
        self.view = mainView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(selected))
    }
    @objc func selected() {
        // 값 전달
        
        self.dismiss(animated: true)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true)
    }
}
