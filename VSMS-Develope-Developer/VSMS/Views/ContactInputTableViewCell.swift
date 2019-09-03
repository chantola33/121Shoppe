//
//  ContactInputTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/10/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ContactInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var NameCheck: UIImageView!
    @IBOutlet weak var PhoneCheck: UIImageView!
    @IBOutlet weak var EmailCheck: UIImageView!
    @IBOutlet weak var AddressCheck: UIImageView!
    
    
    var passingData = CellClickViewModel()
    weak var setValueDelegate: getValueFromXibContact?
    var IsLoadUser = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        InitailValueByUser()
    }
    
    
    @IBAction func txtNameChangeHandle(_ sender: UITextField) {
        if sender.text!.count > 0 {
            NameCheck.Inputchecked()
        }
        else{
            NameCheck.InputCrossed()
        }
        
        passingData.ID = sender.text!
        passingData.Value = sender.text!
        setValueDelegate?.getName(value: passingData)
    }
    
    @IBAction func txtPhoneNumberChange(_ sender: UITextField) {
        if sender.text!.count > 8 {
            PhoneCheck.Inputchecked()
        }
        else{
            PhoneCheck.InputCrossed()
        }
        
        passingData.ID = sender.text!
        passingData.Value = sender.text!
        setValueDelegate?.getPhoneNumber(value: passingData)
    }
    
    @IBAction func txtEmailChangeHandle(_ sender: UITextField) {
        passingData.ID = sender.text!
        passingData.Value = sender.text!
        setValueDelegate?.getEmail(value: passingData)
    }
    
    
    
    func InitailValueByUser(){
        guard IsLoadUser else {
            return
        }
        
        switch passingData.IndexPathKey?.row {
        case 0:
            //txtName.text = User.getUsername()
            break
        case 1:
            txtPhoneNumber.text = User.getUsername()
            PhoneCheck.Inputchecked()
        default:
            print("default")
        }
        IsLoadUser = false
    }
}
