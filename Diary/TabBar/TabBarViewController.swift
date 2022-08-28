
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarController()
        setupTabBarAppearence()
        print(self.tabBar.frame.height)

    }
    
    func configureTabBarController() {
        let firstVC = HomeViewController()
        //firstVC.tabBarItem.title = "일기" // 내비게이션으로 추가하면 타이틀 적용안됨
        let firstNav = UINavigationController(rootViewController: firstVC)
        firstNav.tabBarItem.title = "일기"
        firstNav.tabBarItem.image = UIImage(systemName: "calendar")
        
        let secondVC = SearchViewController()
        let secondNav = UINavigationController(rootViewController: secondVC)
        secondNav.tabBarItem.title = "검색"
        secondNav.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let thirdVC = BackupAndRestoreViewController()
        let thirdNav = UINavigationController(rootViewController: thirdVC)
        thirdNav.tabBarItem.title = "설정"
        thirdNav.tabBarItem.image = UIImage(systemName: "gear")
        
        self.setViewControllers([firstNav, secondNav, thirdNav], animated: true)
    }
    
    func setupTabBarAppearence() {
        let appearence = UITabBarAppearance()
    }
}
