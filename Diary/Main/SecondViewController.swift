import UIKit

class SecondViewController: BaseViewController {
    
    var mainView = SecondView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(selectButtonClicked))
        
        collectionViewDelegate()
    }
    
    @objc func selectButtonClicked() {
        // 값 전달
        self.dismiss(animated: true)
    }
    
    @objc func cancelButtonClicked() {
        self.dismiss(animated: true)
    }
    
    // 이곳에 하는 게 맞을까?
    func collectionViewDelegate() {
        mainView.secondCollectionView.delegate = self
        mainView.secondCollectionView.dataSource = self
        mainView.secondCollectionView.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: SecondCollectionViewCell.reusebleIdentifier)
    }
}

// 이곳에 하는 게 맞을까?
extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCollectionViewCell.reusebleIdentifier, for: indexPath) as? SecondCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}
