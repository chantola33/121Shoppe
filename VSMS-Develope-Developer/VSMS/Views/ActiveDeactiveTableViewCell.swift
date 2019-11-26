//
//  ActiveDeactiveTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/1/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ActiveDeactiveTableViewCell: UITableViewCell {

    @IBOutlet weak var sagement: UISegmentedControl!
    var sagementclick: ((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        sagement.reloadInputViews()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func segmentClickHandle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.sagement.setTitle("active".localizable(), forSegmentAt: 0)
            self.sagementclick!(true)
        }
        else{
            self.sagement.setTitle("history".localizable(), forSegmentAt: 1)
            self.sagementclick!(false)
        }
    }
    
}
