//
//  FacebookHandle.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/30/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import FacebookCore
import FBSDKCoreKit
import FacebookLogin
import SwiftyJSON


class FacebookHandle
{
    static var fbUserData: AccountViewModel?
    
    static func showFacebookConfirmation(from: UIViewController, _ completion: @escaping () -> Void)
    {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [Permission.publicProfile, Permission.email], viewController: from) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                from.view.makeToast(error as? String)
            case .cancelled:
                from.view.makeToast("User cancelled login.")
            case .success(_, _, _):
                FacebookHandle.fetchUser({
                    completion()
                })
            }
        }
    }
    
    
    static func fetchUser(_ completion: @escaping () -> Void)
    {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields":"id,email,name,picture.height(961)"])) { (httpResponse, result, error) in
            if error == nil {
                performOn(.Main, closure: {
                    
                    if result != nil {
                        let data = JSON(result!)
                        
                        AccountViewModel.IsUserExist(userName: "", fbKey: data["id"].stringValue, completion: { (result) in
                            if result {
                                
                            }
                            else {
                                //UserDefaults.standard.set(profileImage, forKey: "profileImageURL")
                                let user = AccountViewModel()
                                user.lastname = data["id"].stringValue
                                user.firstname = data["name"].stringValue
                                user.email = data["email"].stringValue
                                FacebookHandle.fbUserData = user
                                completion()
                            }
                        })
                    }
                    
                })
            }
        }
        connection.start()
    }
}
