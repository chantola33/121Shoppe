//
//  TabBarButton.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/10/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import SideMenuSwift

class TabBarButton: UIView {
    
    @IBInspectable var HomeActive: Bool = false
    @IBInspectable var ProfileActive: Bool = false
    @IBInspectable var NotificationActive: Bool = false
    @IBInspectable var CameraActive: Bool = false
    @IBInspectable var ChatActive: Bool = false

    @IBOutlet private var content: UIView!
    @IBOutlet private weak var Home: UIImageView!
    @IBOutlet private weak var Notification: UIImageView!
    @IBOutlet private weak var Camera: UIImageView!
    @IBOutlet private weak var Chat: UIImageView!
    @IBOutlet private weak var Profile: UIImageView!
    
    @IBOutlet private weak var lblHome: UILabel!
    @IBOutlet private weak var lblNotification: UILabel!
    @IBOutlet private weak var lblCamera: UILabel!
    @IBOutlet private weak var lblChat: UILabel!
    @IBOutlet private weak var lblProfile: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizedXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func customizedXib()
    {
        if HomeActive
        {
            Home.image = UIImage(named: "tabHomeActive")
            lblHome.text = "home".localizable()
        }
        
        if CameraActive
        {
            Camera.image = UIImage(named: "tabCameraActive")
            lblCamera.text = "camera".localizable()
        }
        
        if ProfileActive
        {
            Profile.image = UIImage(named: "tabUserActive")
            lblProfile.text = "profile".localizable()
        }
        
        if NotificationActive
        {
            Notification.image = UIImage(named: "tabNotificationActive")
            lblNotification.text = "notification".localizable()
        }
        
        if ChatActive
        {
            Chat.image = UIImage(named: "tabChatActive")
            lblChat.text = "chat".localizable()
        }
    }
    
    private func xibSetup()
    {
        Bundle.main.loadNibNamed("TabBarButton", owner: self, options: nil)
        content.frame = self.bounds
        content.addBorder(toSide: .Top, withColor: UIColor.darkGray.cgColor, andThickness: 0.5)
        self.addSubview(content)
        addTargetTobutton()
    }
    
    private func addTargetTobutton()
    {
        self.Home.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeClick)))
        self.Notification.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NotificationClick)))
        self.Camera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CameraClick)))
        self.Chat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChatClick)))
        self.Profile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileClick)))
    }
    
    @objc
    private func HomeClick()
    {
        guard !HomeActive else {
            return
        }
        
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
            SideMenuTab.modalPresentationStyle = .fullScreen
            currentView.present(SideMenuTab, animated: false, completion: nil)
        }
    }
    
    @objc
    private func ProfileClick()
    {
        if !User.IsUserAuthorized()
        {
            PresentController.LogInandRegister()
            return
        }
        
        guard !ProfileActive else {
            return
        }
        
        if let currentView = UIApplication.topViewController() {
            let ProfileTab: UINavigationController = {
                let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                return UINavigationController(rootViewController: profile)
            }()
            ProfileTab.modalPresentationStyle = .fullScreen
            currentView.present(ProfileTab, animated: false, completion: nil)
        }
    }
    
    @objc
    private func CameraClick()
    {
        if !User.IsUserAuthorized()
        {
            PresentController.LogInandRegister()
            return
        }
        
        if let currentView = UIApplication.topViewController() {
            let PostAD: UINavigationController = {
                let postVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
                return UINavigationController(rootViewController: postVC)
            }()
            PostAD.modalPresentationStyle = .fullScreen
            currentView.present(PostAD, animated: false, completion: nil)
        }
    }
    
    @objc
    private func NotificationClick()
    {
        if !User.IsUserAuthorized()
        {
            PresentController.LogInandRegister()
            return
        }
        
        guard !NotificationActive else {
            return
        }
        
        if let currentView = UIApplication.topViewController() {
            let notificationVC: UINavigationController = {
                let postVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                return UINavigationController(rootViewController: postVC)
            }()
            notificationVC.modalPresentationStyle = .fullScreen
            currentView.present(notificationVC, animated: false, completion: nil)
        }
    }
    
    @objc
    private func ChatClick()
    {
        if !User.IsUserAuthorized()
        {
            PresentController.LogInandRegister()
            return
        }
        
        guard !ChatActive else {
            return
        }
        
        if let currentView = UIApplication.topViewController() {
            let chatVC: UINavigationController = {
                let postVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                return UINavigationController(rootViewController: postVC)
            }()
            chatVC.modalPresentationStyle = .fullScreen
            currentView.present(chatVC, animated: false, completion: nil)
        }
    }
}

