//
//  VerifyViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/21/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import SCLAlertView

class VerifyViewController: UIViewController {

    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!

    var account = AccountViewModel()
    var is_login = false
    
    //Firebase Reference
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblPhoneNumber.text = account.username
        
        txtCode.addDoneButtonOnKeyboard()
        txtCode.becomeFirstResponder()
        
        self.account.ProfileData.telephone  = self.account.username
    }
    
    @IBAction func verifyHandle(_ sender: Any) {
        verify()
    }
    
    @IBAction func resendHandle(_ sender: Any) {
        
    }
    
    func verify()
    {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: txtCode.text!)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.lblErrorMessage.isHidden = false
                self.txtCode.text = ""
                self.txtCode.becomeFirstResponder()
                print(error as? String)
                return
            }
            
            //Is log or Register
            performOn(.Main, closure: {
                if self.is_login {
                    self.LogInUser()
                }
                else
                {
                    let NewUserFireBase = UserFireBase()
                    NewUserFireBase.id = authResult!.user.uid
                    NewUserFireBase.username = self.account.username
                    NewUserFireBase.password = self.account.password
                    NewUserFireBase.search = self.account.username.lowercased()
                    NewUserFireBase.Save({
                        
                    })
                    self.RegisterUser()
                }
            })
        }
    }
    
    func RegisterUser()
    {
        account.RegisterUser { (result) in
            performOn(.Main, closure: {
                if result {
                    Message.SuccessMessage(message: "Your Account has been registered.", View: self, callback: {
                        PresentController.ProfileController(animate: true)
                    })
                }
                else{
                    Message.AlertMessage(message: "User is already exist. Please try agian later.", header: "Warning", View: self, callback: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }
    }

    func LogInUser()
    {
        Message.SuccessMessage(message: "Log in successfully.", View: self) {
            PresentController.ProfileController(animate: true)
        }
    }
}
