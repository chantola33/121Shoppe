//
//  AboutUsTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/11/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblabout121: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
        
//        lblabout121.text = NSLocalizedString("abount121", comment: "String")
        lblabout121.text = "about121".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
