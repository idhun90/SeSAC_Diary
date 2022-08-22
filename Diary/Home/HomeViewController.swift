import UIKit

class HomeViewController: BaseViewController {
    
    let mainView = HomeView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "일기장"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        self.mainView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reusebleIdentifier)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reusebleIdentifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}
