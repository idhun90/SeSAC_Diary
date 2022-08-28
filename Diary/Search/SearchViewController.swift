import UIKit

class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    
    let searchBar: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "일기 검색"
        view.hidesNavigationBarDuringPresentation = true // searchBar를 탭하여 활성화 됐을 때 타이틀 유지하기, true = 없어짐 (공백 없어져서 이게 좋은 듯)
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = false // 스크롤할 때 searchBar 고정여부, false = 고정
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewTableViewCell.reusebleIdentifier, for: indexPath) as? SearchViewTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
