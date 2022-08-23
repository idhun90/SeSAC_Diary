import UIKit

import Kingfisher
import RealmSwift

class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    let localRealm = try! Realm()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarUI()

    }
    
    func navigationBarUI() {
        navigationItem.largeTitleDisplayMode = .never // 해당 코드가 없으면 현재 페이지에서도 타이틀이 없어도 타이틀이 큰 화면으로 나타나면서 네비게이션바와 이미지뷰 사이에 여백이 생기게 된다.
//        navigationController?.navigationBar.prefersLargeTitles = false
        //여기서 false하면 이전 페이지에도 영향이 있었음.
        title = "일기 작성"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(ClickedSaveButton))
    }
    
    @objc func ClickedSaveButton() {
        let task = USerDiary(title: "오늘의 일기\(Int.random(in: 1...100))", content: "테스트", date: Date(), createdDate: Date(), photo: nil)
        
        try! localRealm.write {
            localRealm.add(task)
            print("Realm add Succed")
            self.navigationController?.popViewController(animated: true)
        }
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
