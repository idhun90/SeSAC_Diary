import UIKit

import RealmSwift
import Accelerate
import FSCalendar

class HomeViewController: BaseViewController {
    
    let mainView = HomeView()
    
    let repository = UserDiaryRealmRepository()
    
    var tasks: Results<USerDiary>! {
        didSet {
            print(#function)
            print("didSet 작동되라~~")
            print("=======================")
        }
    } //didSet 구문 활용해보기
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        navigationBarUI()
        todayDiary()
        print("Realms 파일 위치:", repository.fetchRealmPath())
        print("=============================================================")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
//        renewDate()
        mainView.calendar.reloadData()
        mainView.tableView.reloadData()
        //print("지금 시간 \(Date().formatted())")
        
    }
    
    func renewDate() {
        print(#function)
        tasks = repository.fetchRealm()
    }
    
    // 현재 날짜로 리스트 보여주기
    func todayDiary() {
        print(#function)
        tasks = repository.fetchRealmTodayDate()
        print(tasks!)
        self.mainView.tableView.reloadData()
    }
    
    func navigationBarUI() {
        //title = "일기장" // 네비게이션, 탭바 타이틀이 같은 값으로 설정된다.
        navigationItem.title = "일기장"
        navigationController?.navigationBar.prefersLargeTitles = false // 캘린더 추가로 비활성화. 스크롤 문제 생김
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        let optionButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "slider.horizontal.3"/*ellipsis.circle*/), primaryAction: nil, menu: setupUIMenu())
        navigationItem.rightBarButtonItems = [writeButton, optionButton]
    }
    
    func setupUIMenu() -> UIMenu {
        
        // 정렬
        var sortChildren: [UIAction] {
            let title = UIAction(title: "제목") { _ in
                self.tasks = self.repository.fetchRealmSort(sort: "title", ascending: true)
                self.mainView.tableView.reloadData()
                // 이렇게 할 경우 선택한 날짜에 보여지는 리스트들이 달라짐. 조건문을 여러 개 만들어야하나?
                // 렘 코드 분리 후 다시 도전
            }
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
        
        // 설정(백업 및 복원) 0828 탭바 추가로 기능 비활성화
        //        let restoreAndbackup = UIAction(title: "백업 및 복원", image: UIImage(systemName: "arrow.counterclockwise.circle")) { _ in
        //
        //            let vc = BackupAndRestoreViewController()
        //            self.transition(viewController: vc, transitionStyle: .presentNavigation)
        //        }
        //
        //        let restoreAndBackupMenu = UIMenu(options: .displayInline, children: [restoreAndbackup])
        
        let menu = UIMenu(title: "", options: .displayInline, children: [sortMenu, filterMenu/*, restoreAndBackupMenu*/])
        
        return menu
    }
    
    @objc func writeButtonClicked() {
        print(#function, String(describing: HomeViewController.self))
        let vc = MainViewController()
        transition(viewController: vc, transitionStyle: .presentFullScreen)
        
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        self.mainView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reusebleIdentifier)
        
        self.mainView.calendar.delegate = self
        self.mainView.calendar.dataSource = self
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("선택한 날짜는 \(date)입니다.") // 기존 포멧 체크용
        print("선택한 날짜는 \(self.mainView.formatter.string(from: date))입니다.")
        tasks = repository.fetchRealmDate(date: date)
        self.mainView.tableView.reloadData()
        //self.mainView.calendar.reloadData() // 캘린더를 리로드하면 특정 날짜를 아주 빠르게 클릭하는 애니메이션 효과가 생김, 리로드 할 필요는 없는 듯.
        //테이블뷰, 캘린더 갱신 필요?
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return self.mainView.formatter.string(from: date) == "20220908" ? "애플 키노트" : nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let numberOfEvents = repository.fetchRealmDate(date: date)
        return numberOfEvents.count
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
            
            // 이미지가 없을 때 삭제하면 콘솔창 오류 문구 발생 -> 조건문 추가 해결
            guard let imageDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("이미지 폴더") else { return }
            let imageURL = imageDirectoryURL.appendingPathComponent("\(taskToDelete.objectId).jpg")
            
            if FileManager.default.fileExists(atPath: imageURL.path) {
                removeImageFromImageDirectory(fileName: "\(taskToDelete.objectId).jpg") // 이미지도 함께 삭제, realms 보다 늦게 삭제되면 .objectId record가 바뀜. 오류 발생
                print("삭제할 이미지가 존재합니다. 데이터와 함께 삭제됩니다.")
            } else {
                print("삭제할 이미지가 존재하지 않습니다. 데이터만 삭제됩니다.")
            }
            
            repository.fetchDeleteRealmItem(item: taskToDelete)
            mainView.tableView.reloadData()
            mainView.calendar.reloadData()
        }
    }
}
