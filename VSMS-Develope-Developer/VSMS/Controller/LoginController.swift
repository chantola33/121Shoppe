//
//  LoginController.swift
//  VSMS
//
//  Created by usah on 3/20/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import SCLAlertView
import SwiftyJSON


class LoginController: UIViewController {
    
    @IBOutlet weak var logo121: UIImageView!
    @IBOutlet weak var Loginbutton: UIButton!
    @IBOutlet weak var Registerbutton: UIButton!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var fbButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ShowDefaultNavigation()
        fbButton.addTarget(self, action: #selector(LogInFacebook), for: UIControl.Event.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        User.resetUserDefault()
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func LogInFacebook()
    {
        FacebookHandle.showFacebookConfirmation(from: self) {
            if let user = FacebookHandle.fbUserData {
                PresentController.PushToSetNumberViewController(user: user, from: self)
            }
        }
    }
}


