import UIKit

import SnapKit

class HomeView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemBackground
        return view
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
        self.backgroundColor = .systemBackground
        
        
    }
    
    override func setConstaints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
