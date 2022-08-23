import UIKit

class HomeTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: USerDiary) {
        textLabel?.text = data.title
    }
    
    override func configure() {
        self.backgroundColor = .systemBackground
    }
    
    override func setConstaints() {
        
    }
}
