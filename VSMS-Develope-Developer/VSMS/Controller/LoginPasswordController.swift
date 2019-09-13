//
//  LoginPasswordController.swift
//  VSMS
//
//  Created by Vuthy Tep on 6/28/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class LoginPasswordController: UIViewController {
    
    @IBOutlet weak var textphonenumber: UITextField!
    @IBOutlet weak var textpassword: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    
    var account = AccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginbutton.reloadInputViews()

        //if user is already logged in switching to profile screen
        
        textphonenumber.returnKeyType = .next
        textphonenumber.delegate = self
        
        textpassword.returnKeyType = .done
        textpassword.addDoneButtonOnKeyboard()
        textpassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textpassword.text = ""
        textphonenumber.text = ""
    }
    
    @IBAction func btnFacebookClick(_ sender: Any) {
        FacebookHandle.showFacebookConfirmation(from: self) {
            if let user = FacebookHandle.fbUserData {
                AccountViewModel.IsUserExist(userName: "", fbKey: user.lastname, completion: { (result) in
                    if result {
                        user.password = user.username
                        user.LogInUser(completion: { (result) in
                            PresentController.ProfileController()
                        })
                    }
                    else {
                        PresentController.PushToSetNumberViewController(user: user, from: self)
                    }
                })
            }
        }
    }
    
    @IBAction func LoginbuttonTapped(_ sender: Any) {

        if IsNilorEmpty(value: textphonenumber.text) {
            textphonenumber.becomeFirstResponder()
            return
        }
        
        if IsNilorEmpty(value: textpassword.text) {
            textpassword.becomeFirstResponder()
            return
        }
        
        let phonenumber = textphonenumber.text!
        let password = textpassword.text!
        
        
        account.username = phonenumber
        account.password = password
        
        AccountViewModel.IsUserExist(userName: phonenumber, fbKey: "") { (result) in
            if !result {
                Message.WarningMessage(message: "User is not exist.", View: self, callback: {
                    self.textphonenumber.text = ""
                    self.textpassword.text = ""
                    self.textphonenumber.becomeFirstResponder()
                })
                return
            }
        }
        
        account.LogInUser { (result) in
            performOn(.Main, closure: {
                if result {
                   //self.verifyPhoneNumber()
                    Message.SuccessMessage(message: "Log in successfully.", View: self) {
                        PresentController.ProfileController(animate: true)
                    }
                }
                else{
                    Message.WarningMessage(message: "Incorrect Username and Password", View: self, callback: {
                        self.textpassword.text = ""
                        self.textpassword.becomeFirstResponder()
                    })
                }
            })
        }
    }
    
    private func verifyPhoneNumber()
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(account.username.ISOTelephone(), uiDelegate: nil)
                        { (verificationID, error) in
                            if error != nil {
                                User.resetUserDefault()
                                Message.AttentionMessage(message: "Your number is temporary blocked, due to many requests. Please try again later.", View: self, callback: {
                                    self.textphonenumber.text = ""
                                    self.textpassword.text = ""
                                })
                                return
                            }
        
                            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                            PresentController.PushToVerifyViewController(telelphone: self.textphonenumber.text!, password: self.textpassword.text!, from: self, isLogin: true, FBData: nil)
                        }
    }

}

extension LoginPasswordController
{
    func checkTextField()
    {
        if textphonenumber.text == "" {
            textphonenumber.becomeFirstResponder()
        }
        else if textpassword.text == "" {
            textpassword.becomeFirstResponder()
        }
    }
    
}

extension LoginPasswordController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textphonenumber
        {
            textField.resignFirstResponder()
            textpassword.becomeFirstResponder()
        }
        else if textField == textpassword
        {
            textField.resignFirstResponder()
        }
        return true
    }
}
