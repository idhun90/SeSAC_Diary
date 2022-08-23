import UIKit

import RealmSwift

class HomeViewController: BaseViewController {
    
    let mainView = HomeView()
    
    let localRealm = try! Realm()
    var tasks: Results<USerDiary>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarUI()
        savedDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        mainView.tableView.reloadData()
    }
    
    func savedDate() {
        tasks = localRealm.objects(USerDiary.self).sorted(byKeyPath: "title", ascending: true)
    }
    
    func navigationBarUI() {
        title = "일기장"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        
        let vc = MainViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        vc.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        self.mainView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reusebleIdentifier)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reusebleIdentifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        //cell.textLabel?.text = tasks[indexPath.row].title
        cell.setData(data: tasks[indexPath.row])
        return cell
    }
    
    // 스와이프 구현 전 허용 필요
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 스와이프 기능 구현
    // 삭제 기능 추가
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            try! localRealm.write {
                localRealm.delete(taskToDelete)
                mainView.tableView.reloadData()
            }
        }
    }
    
    
}
