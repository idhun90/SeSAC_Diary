import UIKit

import Kingfisher

class SecondViewController: BaseViewController {
    
    private var mainView = SecondView()
    
    private var page = 1
    private let totalPage = 334 // 한페이지에 30개 불러올 때 기준
    private var unsplashimage: [UnsplashData] = []
    
    var selectedImageUrl: String?
    var dataHandler: (() -> ())?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.photoSearchBar.delegate = self
        
        navigationBarUI()
        setupCollectionView()
        
    }
    
    func navigationBarUI() {
        title = "이미지 검색"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(selectButtonClicked))
    }
    
    // objc 함수
    @objc func selectButtonClicked() {
        dataHandler?()
        unwind(unwindStyle: .dismiss)
    }
    
    @objc func cancelButtonClicked() {
        selectedImageUrl = nil
        unwind(unwindStyle: .dismiss)
    }
    
    // 이곳에 하는 게 맞을까?
    func setupCollectionView() {
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
        guard let text = searchBar.text else { return }
        unsplashimage.removeAll()
        page = 1
        mainView.secondCollectionView.reloadData()
        fetchImage(query: text)
        
        print("검색 버튼 클릭 함")
    }
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function)
        print("======\(indexPaths)")
        //        for indexPath in indexPaths {
        //            if unsplashimage.count - 1 == indexPath.item /*&& page < totalPage*/ {
        //                page += 1
        //                print(page)
        //                guard let text = mainView.photoSearchBar.text else { return }
        //                fetchImage(query: text)
        //            }
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashimage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCollectionViewCell.reusebleIdentifier, for: indexPath) as? SecondCollectionViewCell else { return UICollectionViewCell() }
        cell.roadData(data: unsplashimage[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item) 선택됨")
        
        selectedImageUrl = unsplashimage[indexPath.item].regularImageUrl
        
    }
}
