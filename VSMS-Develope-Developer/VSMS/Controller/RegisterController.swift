//
//  RegisterController.swift
//  VSMS
//
//  Created by usah on 3/20/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class RegisterController: UIViewController {
    
    var defaultUser = UserDefaults.standard
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    func configuration()
    {
        txtPhoneNumber.addDoneButtonOnKeyboard()
        txtPassword.addDoneButtonOnKeyboard()
        txtConfirmPassword.addDoneButtonOnKeyboard()
        ShowDefaultNavigation()
        
    }
    
    
    @IBAction func SubmitHandle(_ sender: Any) {
        Register()
    }
    
    @IBAction func btnRegisterFacebook(_ sender: Any) {
        FacebookHandle.showFacebookConfirmation(from: self) {
            if let user = FacebookHandle.fbUserData {
                AccountViewModel.IsUserExist(userName: "", fbKey: user.lastname, completion: { (result) in
                    if result {
                        user.password = user.username
                        user.LogInUser(completion: { (check) in
                            if check {
                                PresentController.ProfileController()
                            }
                        })
                    }
                    else {
                        PresentController.PushToSetNumberViewController(user: user, from: self)
                    }
                })
            }
        }
    }
    
    
    func Register()
    {
        guard let phonenumber = txtPhoneNumber.text else { return }
        guard let password = txtPassword.text else { return }
        guard let confirmPassword = txtConfirmPassword.text else { return }
        
        if phonenumber == ""
        {
            txtPhoneNumber.becomeFirstResponder()
            return
        }
        else if password == ""
        {
            txtPassword.becomeFirstResponder()
            return
        }
        else if confirmPassword != password
        {
            txtConfirmPassword.text = ""
            txtConfirmPassword.becomeFirstResponder()
            return
        }

        
        //Check if User is existing
        AccountViewModel.IsUserExist(userName: phonenumber, fbKey: "") { (result) in
            if result
            {
                Message.WarningMessage(message: "Phone number is already existing. Please try again.", View: self, callback: {
                    self.resetInput()
                })
            }
            else
            {
                PhoneAuthProvider.provider().verifyPhoneNumber(phonenumber.ISOTelephone(), uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print(error)
                        Message.AlertMessage(message: "\(error)", header: "Error", View: self, callback: {
                            self.resetInput()
                        })
                        return
                    }
                    
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    PresentController.PushToVerifyViewController(telelphone: phonenumber, password: confirmPassword, from: self, isLogin: false, FBData: nil)
                }
            }
        }
    }
    
    func resetInput()
    {
        self.txtPhoneNumber.text = ""
        self.txtPassword.text = ""
        self.txtConfirmPassword.text = ""
        self.txtPhoneNumber.becomeFirstResponder()
    }

}

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
    
    func ISOTelephone() -> String
    {
        let firstChar = self.prefix(1)
        if firstChar == "0" {
            return "+855" + self.subString(from: 1, to: self.count)
        }
        return self
    }
}
