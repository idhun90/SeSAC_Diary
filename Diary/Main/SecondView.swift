import UIKit

import SnapKit

class SecondView: BaseView {
    
    let photoSearchBar: UISearchBar = {
        let view = UISearchBar()
        view.searchBarStyle = .minimal
        return view
    }()
    
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let itemCount: CGFloat = 3
        let width = (UIScreen.main.bounds.width - spacing * (itemCount + 1)) / itemCount
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [photoSearchBar, collection].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstaints() {
        photoSearchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(50)
        }
        
        collection.snp.makeConstraints {
            $0.top.equalTo(photoSearchBar.snp.bottom)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
