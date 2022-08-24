import UIKit

import RealmSwift
import Accelerate

class HomeViewController: BaseViewController {
    
    let mainView = HomeView()
    
    let localRealm = try! Realm()
    var tasks: Results<USerDiary>! //didSet 구문 활용해보기
    
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
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        let optionButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: setupUIMenu())
        navigationItem.rightBarButtonItems = [plusButton, optionButton]
    }
    
    func setupUIMenu() -> UIMenu {
        
        // 정렬
        var sortChildren: [UIAction] {
            let title = UIAction(title: "제목") { _ in }
            let date = UIAction(title: "생성일") { _ in }
            
            return [title, date]
        }
        
        let sortMenu = UIMenu(title: "다음으로 정렬", image: UIImage(systemName: "arrow.up.arrow.down"),options: .singleSelection, children: sortChildren)
        
        // 필터
        var filterChildren: [UIAction] {
            let ascending = UIAction(title: "필터1") { _ in }
            let descending = UIAction(title: "필터2") { _ in }
            
            return [ascending, descending]
        }
        
        let filterMenu = UIMenu(title: "필터", image: UIImage(systemName: "line.3.horizontal.decrease.circle"), options: .singleSelection, children: filterChildren)
        
        // 설정(백업 및 복원)
        let restoreAndbackup = UIAction(title: "백업 및 복원", image: UIImage(systemName: "arrow.counterclockwise.circle")) { _ in
                // 새로운 페이지 이동
                // 백업 버튼, 복원 버튼, 테이블 뷰 구성 필요
            let vc = BackupAndRestoreViewController()
            self.transition(viewController: vc, transitionStyle: .presentNavigation)
            }
        
        let restoreAndBackupMenu = UIMenu(options: .displayInline, children: [restoreAndbackup])
            
        let menu = UIMenu(title: "", options: .displayInline, children: [sortMenu, filterMenu, restoreAndBackupMenu])
        
        return menu
    }
    
    @objc func plusButtonClicked() {
        let vc = MainViewController()
        transition(viewController: vc, transitionStyle: .presentFullScreen)
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        self.mainView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reusebleIdentifier)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reusebleIdentifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        cell.setData(data: tasks[indexPath.row])
        //값전달: 프로토콜
        cell.homeImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        
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
