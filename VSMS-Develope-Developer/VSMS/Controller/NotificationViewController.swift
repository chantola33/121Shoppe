//
//  NotifcationViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/2/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    let noRecordLabel: UILabel = {
       let label = UILabel()
        label.text = "No Notification"
        label.font.withSize(11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling Function here
        config()
        InitailUI()
    }

    // Function & Configuration
    private func config()
    {
        self.ShowDefaultNavigation()
    }
    
    private func InitailUI()
    {
        self.view.addSubview(noRecordLabel)
        noRecordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noRecordLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
