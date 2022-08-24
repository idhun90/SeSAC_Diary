import UIKit
import PhotosUI

import Kingfisher
import RealmSwift

// 값전달: 프로토콜
protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

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
        // 텍스트 -> Realm 저장, 이미지 -> Document 저장
        
        guard let title = self.mainView.titleTextField.text else {
            print("제목을 입력하세요.")
            // Alret
            return
        }
        
        let task = USerDiary(title: title, content: self.mainView.mainTextView.text!, date: Date(), createdDate: Date(), photo: nil)
        
        // try! 보다는 try do catch 구문 권장
        do {
            try localRealm.write {
                localRealm.add(task)
                print("Realm 저장 성공")
            }
        } catch let error {
            print("Realm 저장 실패", error)
        }
        
        // 텍스트를 Realm에 저장하고 나서, 이미지는 Document에 저장
        if let image = mainView.photoImageView.image {
            saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
            print("이미지 도큐먼트에 저장됨")
        } else {
            print("이미지 도큐먼트에 저장안됨")
        }
        
        unwind(unwindStyle: .dismiss)
    }
    
    @objc func cancelButtonClicked() {
        unwind(unwindStyle: .dismiss)
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
                
//                vc.dataHandler = {
//                    if let selectedImageUrl = vc.selectedImageUrl {
//                        let url = URL(string: selectedImageUrl)
//                        self.mainView.photoImageView.kf.setImage(with: url)
//                    } else {
//                        self.mainView.photoImageView.image = UIImage(systemName: "xmark")
//                    }
//                }
                
                // 값전달: 프로토콜
                vc.delegate = self
                
                self.transition(viewController: vc, transitionStyle: .presentNavigation)
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
        self.mainView.choiceButton.menu = UIMenu(title: "", options: .displayInline, children: childeren)
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

//값전달: 프로토콜
extension MainViewController: SelectImageDelegate {
    func sendImageData(image: UIImage) {
        self.mainView.photoImageView.image = image
        print(#function)
    }
}
