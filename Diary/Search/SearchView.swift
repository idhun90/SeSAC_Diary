import UIKit

import SnapKit

class SearchView: BaseView {
    
    let searchBar: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "일기 검색"
        view.hidesNavigationBarDuringPresentation = true // searchBar를 탭하여 활성화 됐을 때 타이틀 유지하기, true = 없어짐 (공백 없어져서 이게 좋은 듯)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(SearchViewTableViewCell.self, forCellReuseIdentifier: SearchViewTableViewCell.reusebleIdentifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.addSubview(tableView)
        self.backgroundColor = .systemGray6
    }
    
    override func setConstaints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

