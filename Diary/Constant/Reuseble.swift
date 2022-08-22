import UIKit

public protocol ReusebleProtocol {
    static var reusebleIdentifier: String { get }
}

extension UIViewController: ReusebleProtocol {
    public static var reusebleIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusebleProtocol {
    public static var reusebleIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusebleProtocol {
    public static var reusebleIdentifier: String {
        return String(describing: self)
    }
}
