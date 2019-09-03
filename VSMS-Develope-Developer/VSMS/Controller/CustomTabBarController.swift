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
    case home, camera, profile
    
    var title: String {
        switch self {
        case .home:
         return "Home"
        case .camera:
         return "Camera"
        case .profile:
         return "Profile"
        
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            return UIImage.init(named: "icons8-home-50")!
        case .camera:
            return UIImage.init(named: "icons8-camera-50")!
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
        let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
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
    
    let PostAdTab: UINavigationController = {
        let postAd = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        return UINavigationController(rootViewController: postAd)
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
        
        viewControllers = [SideMenuTab, PostAdTab, ProfileTab]
        
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
        case ProfileTab:
            if tabBarController.selectedIndex == 2 && !User.IsUserAuthorized(){
                return false
            }
            return true
        default: return true
        }
    }
}
