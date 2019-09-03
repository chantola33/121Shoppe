//
//  SetPhoneViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/28/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class SetPhoneViewController: UIViewController {

    //Properties
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnSubmit: BottomDetail!
    
    var UserAccount: AccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Configuration
        Config()
    }
    
    private func Config()
    {
        txtPhoneNumber.addDoneButtonOnKeyboard()
        txtPhoneNumber.becomeFirstResponder()
    }

    @IBAction func submitHandle(_ sender: Any) {
        
        if IsNilorEmpty(value: txtPhoneNumber.text)
        {
            self.view.makeToast("Phone Number is required")
            return
        }
        
        UserAccount?.username = txtPhoneNumber.text!
        checkNumber()
    }
    
    private func checkNumber()
    {
        AccountViewModel.IsUserExist(userName: txtPhoneNumber.text!, fbKey: "") { (result) in
            if result {
                Message.WarningMessage(message: "Phone number is existing. Please enter new number again.", View: self, callback: {
                    self.txtPhoneNumber.text = ""
                    self.txtPhoneNumber.becomeFirstResponder()
                    return
                })
            }
            else {
                self.VerifyPhone()
            }
        }
    }
    
    func VerifyPhone()
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(txtPhoneNumber.text!.ISOTelephone(), uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error)
                Message.AlertMessage(message: "\(error)", header: "Error", View: self, callback: {
                    
                })
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            PresentController.PushToVerifyViewController(telelphone: self.txtPhoneNumber.text!, password: self.UserAccount!.username, from: self, isLogin: false, FBData: self.UserAccount)
        }
    }
    
}
