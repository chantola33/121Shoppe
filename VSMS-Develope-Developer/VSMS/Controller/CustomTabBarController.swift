//
//  CustomTabBarController.swift
//  VSMS
//
//  Created by Vuthy Tep on 6/29/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import SideMenuSwift

enum VSMSTabBar: Int {
    case home, notification, camera, chat,profile
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .notification:
            return "Notification"
        case .camera:
            return "Camera"
        case .chat:
            return "Chat"
        case .profile:
         return "Profile"
        
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            return UIImage.init(named: "icons8-home-50")!
        case .notification:
            return UIImage.init(named: "icons8-notification-50")!
        case .camera:
            return UIImage.init(named: "icons8-camera-50")!
        case .chat:
            return UIImage.init(named: "icons8-chat-bubble-50")!
        case .profile:
            return UIImage.init(named: "icon-messages-app-27x20")!
        }
    }
}

class CustomTabBarController: UITabBarController {
    
    
    let LoginTab: UINavigationController = {
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        return UINavigationController(rootViewController: login)
    }()
    
    let ProfileTab: UINavigationController = {
        let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        return UINavigationController(rootViewController: profile)
    }()
    
    let SideMenuTab: SideMenuController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenu") as! MyNavigation
        
        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leftMenu") as! MenuViewController
        menuViewController.delegate = contentViewController
        
        let sideMenuController = SideMenuController(
            contentViewController: contentViewController,
            menuViewController: menuViewController)
        return sideMenuController
    }()
    let NotificationTab: UINavigationController = {
        let notication = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        return UINavigationController(rootViewController: notication)
    }()
    
    let PostAdTab: UINavigationController = {
        let postAd = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        return UINavigationController(rootViewController: postAd)
    }()
    
    let ChatTab: UINavigationController = {
        let chat = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        return UINavigationController(rootViewController: chat)
    }()
    
    override var tabBar: UITabBar {
        let _tabar = super.tabBar
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.254701972, green: 0.5019594431, blue: 1, alpha: 1)
        _tabar.barTintColor = .white
        _tabar.isTranslucent = false
        _tabar.backgroundColor = .white
        return _tabar
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setuptabBar()
        configureSideMenu()
    }
    
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        
    }

    fileprivate func setuptabBar () {
        
        viewControllers = [SideMenuTab, NotificationTab, PostAdTab, ChatTab, ProfileTab]
        
       for (index, bar) in self.tabBar.items!.enumerated() {
            bar.image = VSMSTabBar(rawValue: index)?.image
            bar.title = VSMSTabBar(rawValue: index)?.title
        }
        
    }

}

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController.selectedIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        switch viewController {
        case PostAdTab:
            if tabBarController.selectedIndex == 1 && !User.IsUserAuthorized(){
                return false
            }
            self.tabBar.isHidden = true
            return true
        case NotificationTab:
            if tabBarController.selectedIndex == 2 && !User.IsUserAuthorized(){
                return false
            }
            return true
        case ChatTab:
            if tabBarController.selectedIndex == 3 && !User.IsUserAuthorized(){
                return false
            }
            return true
        case ProfileTab:
            if tabBarController.selectedIndex == 4 && !User.IsUserAuthorized(){
                return false
            }
            return true
        default: return true
        }
    }
}
