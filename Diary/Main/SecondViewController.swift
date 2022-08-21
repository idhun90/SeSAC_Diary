import UIKit

import Kingfisher

class SecondViewController: BaseViewController {
    
    private var mainView = SecondView()
    
    private var page = 1
    private let totalPage = 1000
    private var unsplashimage: [UnsplashData] = []
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        mainView.photoSearchBar.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(selectButtonClicked))
        
        collectionViewDelegate()
        
        APIManager.shared.fetchImage(query: "Cat", page: page) {
            self.unsplashimage = $0
            print(self.unsplashimage)
        }
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
        mainView.secondCollectionView.prefetchDataSource = self
        mainView.secondCollectionView.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: SecondCollectionViewCell.reusebleIdentifier)
    }
    
    func fetchImage(query: String) {
        APIManager.shared.fetchImage(query: query, page: page) {
            self.unsplashimage = $0
            self.mainView.secondCollectionView.reloadData()
        }
        
    }
}

// 이곳에 하는 게 맞을까?
extension SecondViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 네트워크 처리 필요
        guard let text = searchBar.text else { return }
        unsplashimage.removeAll()
        page = 1
        fetchImage(query: text)
        
        print("검색 버튼 클릭 함")
    }
    
    
}
extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if unsplashimage.count == indexPath.item && page < totalPage {
                page += 1
                
                guard let text = mainView.photoSearchBar.text else { return }
                fetchImage(query: text)
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashimage.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCollectionViewCell.reusebleIdentifier, for: indexPath) as? SecondCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: unsplashimage[indexPath.item].regularImageUrl)
        cell.searchedImageView.kf.setImage(with: url)
        
        
        return cell
    }
    
    
}
