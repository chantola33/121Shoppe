//
//  PhoneNumberInputHeaderTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/10/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class PhoneNumberInputHeaderTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnAddNewPhoneNumber: UIButton!
    
    var addNewPhoneNumberHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addNewPhoneNumberHandlerFunc(_ sender: UIButton) {
        self.addNewPhoneNumberHandler!()
    }
    
}
