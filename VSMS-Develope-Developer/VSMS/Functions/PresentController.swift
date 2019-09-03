//
//  PresentController.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/15/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import SideMenuSwift

class PresentController
{
    /////////////////Home Page///////////////
    static func HomePage()
    {
        if let currentView = UIApplication.topViewController() {
            let SideMenuTab: SideMenuController = {
                let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenu") as! MyNavigation
                
                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leftMenu") as! MenuViewController
                menuViewController.delegate = contentViewController
                
                let sideMenuController = SideMenuController(
                    contentViewController: contentViewController,
                    menuViewController: menuViewController)
                return sideMenuController
            }()
            currentView.present(SideMenuTab, animated: false, completion: nil)
        }
    }
    
    /////////////////Profile///////////////
    static func ProfileController(animate: Bool = false)
    {
        if let currentView = UIApplication.topViewController() {
            let ProfileTab: UINavigationController = {
                let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
                return UINavigationController(rootViewController: profile)
            }()
            currentView.present(ProfileTab, animated: animate, completion: nil)
        }
    }
    
    static func ChangePassword(from: UIViewController)
    {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordController") as? ChangePasswordController
        {
            from.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    static func LogInandRegister()
    {
        if let currentView = UIApplication.topViewController() {
            let ProfileTab: UINavigationController = {
                let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                return UINavigationController(rootViewController: profile)
            }()
            currentView.present(ProfileTab, animated: true, completion: nil)
        }
    }
    
    static func PushToEditPostViewController(postID: Int, from: UIViewController)
    {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as? PostViewController
        {
            viewController.post_id = postID
            from.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    static func PushToEditProfileViewController(from: UIViewController)
    {
        if let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyAccountController") as? MyAccountController
        {
            from.navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    static func PushToVerifyViewController(telelphone: String, password: String, from: UIViewController, isLogin: Bool = false, FBData: AccountViewModel?)
    {
        if let verifyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController
        {
            verifyVC.account.username = telelphone
            verifyVC.account.password = password
            
            if FBData != nil {
                verifyVC.account.firstname = FBData!.firstname
                verifyVC.account.email = FBData!.email
            }
            
            verifyVC.is_login = isLogin
            from.navigationController?.pushViewController(verifyVC, animated: true)
        }
    }
    
    
    static func PushToSetNumberViewController(user: AccountViewModel, from: UIViewController)
    {
        if let setNumberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetPhoneViewController") as? SetPhoneViewController
        {
            setNumberVC.UserAccount = user
            from.navigationController?.pushViewController(setNumberVC, animated: true)
        }
    }
    
    static func PushToMessageViewController(from: UIViewController)
    {
        if let messageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewMessageViewController") as? NewMessageViewController
        {
            from.navigationController?.pushViewController(messageVC, animated: true)
        }
    }
}
