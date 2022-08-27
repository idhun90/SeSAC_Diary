import UIKit

import SnapKit
import FSCalendar

class HomeView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .systemGray6
        return view
    }()
    
    lazy var calendar: FSCalendar! = {
        let view = FSCalendar()
        view.backgroundColor = .white
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.headerDateFormat = "yyyy년 MM월" // 헤더 날짜 포맷 설정
        view.appearance.headerTitleAlignment = .center // 헤더 정렬
        view.appearance.weekdayTextColor = .black // 달력 요일 색상 변경
        view.appearance.headerTitleColor = .black
        view.appearance.titleWeekendColor = .systemRed // 주말 날짜 텍스트 색상 변경
        view.appearance.selectionColor = .black
        view.appearance.todayColor = .systemRed
        view.appearance.headerMinimumDissolvedAlpha = 0.0 // 양 옆 이전 월, 다음 월 표기 없애기
        view.scrollDirection = .vertical
        return view
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // self.addSubview(tableView)
        // 이 위치에 했더니 오류 남. 주의 -> because they have no common ancestor.  Does the constraint or its anchors reference items in different view hierarchies?  That's illegal.'
        // NavigationBar 여기엔 왜 안되지?
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.addSubview(tableView)
        self.addSubview(calendar)
        self.backgroundColor = .systemGray6
    }
    
    override func setConstaints() {
        
        calendar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
