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


class LoginController: BaseViewController {
    
    @IBOutlet weak var logo121: UIImageView!
    @IBOutlet weak var Loginbutton: UIButton!
    @IBOutlet weak var Registerbutton: UIButton!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var fbButton: UIButton!
    
    
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ShowDefaultNavigation()
        fbButton.addTarget(self, action: #selector(LogInFacebook), for: UIControl.Event.touchUpInside)
    }
    
    override func localizeUI() {
        lblLogin.text = "login".localizable()
        lblOr.text = "or".localizable()
        lblFacebook.text = "quick".localizable()
        Loginbutton.setTitle("loginbutton".localizable(), for: .normal)
        Registerbutton.setTitle("registerbutton".localizable(), for: .normal)
        fbButton.setTitle("facebook".localizable(), for: .normal)
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


