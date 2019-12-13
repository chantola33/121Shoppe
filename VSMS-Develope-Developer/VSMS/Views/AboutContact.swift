//
//  AboutContact.swift
//  VSMS
//
//  Created by thou on 12/11/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit
class AboutContach: UITableViewCell {
    
    @IBOutlet weak var lblcontact: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        lblcontact.text = "contact121".localized

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

