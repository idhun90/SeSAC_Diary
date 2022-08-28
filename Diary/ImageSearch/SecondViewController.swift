import UIKit

import Kingfisher

class SecondViewController: BaseViewController {
    
    private var mainView = SecondView()
    
    // 값전달: 프로토콜
    var delegate: SelectImageDelegate? //
    var selectIndexPath: IndexPath?
    var selectImage: UIImage?
    
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
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // objc 함수
    @objc func selectButtonClicked() {
        //dataHandler?()
        
        // 값전달: 프로토콜
        guard let selectImage = selectImage else {
            print("사진을 선택해주세요.")
            // Alret 추가
            return
        }
        
        // 값전달: 프로토콜
        // 선택한 이미지를 전송
        delegate?.sendImageData(image: selectImage)

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
        
        title = "사진이 선택됨"
        navigationItem.rightBarButtonItem?.isEnabled = true // 사진을 선택했을 때 '선택' 버튼 활성화
        
        selectedImageUrl = unsplashimage[indexPath.item].regularImageUrl
        
//        // 선택한 Cell 이미지 가져오기
        guard let cell = collectionView.cellForItem(at: indexPath) as? SecondCollectionViewCell else { return }
        
        selectImage = cell.searchedImageView.image
        
        // 선택한 cell indexPath 저장
        selectIndexPath = indexPath
//        collectionView.reloadData() // 왜 리로드했더라..?
        
    }
}
