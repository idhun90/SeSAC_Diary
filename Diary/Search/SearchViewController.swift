import UIKit

import RealmSwift

class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    
    let repository = UserDiaryRealmRepository()
    
    var searchResult: Results<USerDiary>!
        
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
        self.navigationItem.searchController = self.mainView.searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = false // 스크롤할 때 searchBar 고정여부, false = 고정
        
        self.mainView.searchBar.searchResultsUpdater = self
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
        guard let text = searchController.searchBar.text else { return }
        let result = repository.fetchRealmFilterTextContainTitleOrContent(text: text)
        print(result)
        searchResult = result
        self.mainView.tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult == nil ? 0 : searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewTableViewCell.reusebleIdentifier, for: indexPath) as? SearchViewTableViewCell else { return UITableViewCell() }
        
        cell.setData(data: searchResult[indexPath.row])
        
        return cell
    }
}
