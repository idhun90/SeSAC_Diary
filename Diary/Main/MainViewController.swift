import UIKit
import PhotosUI

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
        setupUIMenu()
    }
    
    func navigationBarUI() {
        navigationItem.largeTitleDisplayMode = .never
        title = "일기 작성"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(ClickedSaveButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    @objc func ClickedSaveButton() {
        let task = USerDiary(title: "오늘의 일기\(Int.random(in: 1...100))", content: "테스트", date: Date(), createdDate: Date(), photo: nil)
        
        try! localRealm.write {
            localRealm.add(task)
            print("Realm add Succed")
            unwind(unwindStyle: .pop)
        }
    }
    
    @objc func cancelButtonClicked() {
        self.dismiss(animated: true)
    }
    
    override func configure() {
        mainView.choiceButton.addTarget(self, action: #selector(clickedChoiceButton), for: .touchUpInside)
        print(#function)
    }
    
    @objc func clickedChoiceButton() {
        print(#function)
        setupUIMenu()
    }
    
    func setupUIMenu() {
        var childeren: [UIAction] {
            
            let search = UIAction(title: "검색", image: UIImage(systemName: "magnifyingglass")) { _ in
                
                let vc = SecondViewController()
                
                vc.dataHandler = {
                    if let selectedImageUrl = vc.selectedImageUrl {
                        let url = URL(string: selectedImageUrl)
                        self.mainView.photoImageView.kf.setImage(with: url)
                    } else {
                        self.mainView.photoImageView.image = UIImage(systemName: "xmark")
                    }
                }
                
                self.transition(viewController: vc, transitionStyle: .presentFullScreen)
            }
            
            let camera = UIAction(title: "카메라", image: UIImage(systemName: "camera")) { _ in
                print("카메라 선택")
                
                let picker = UIImagePickerController()
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                
                self.present(picker, animated: true)
            }
            
            let photoAlbum = UIAction(title: "앨범", image: UIImage(systemName: "photo")) { _ in
                print("사진 앨범 선택")
                
                // PHPickerViewController
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 1
                configuration.filter = .images
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                
                self.present(picker, animated: true, completion: nil)
            }
            
            return [camera, photoAlbum, search]
        }
        self.mainView.choiceButton.menu = UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: childeren)
        self.mainView.choiceButton.showsMenuAsPrimaryAction = true
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.mainView.photoImageView.image = image
            unwind(unwindStyle: .dismiss)
            print("정상 작동")
        }
    }
    
}

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.mainView.photoImageView.image = image as? UIImage
                }
            }
        } else {
            print("오류 발생")
        }
    }
}
