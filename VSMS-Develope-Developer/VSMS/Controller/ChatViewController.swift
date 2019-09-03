//
//  ChatViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/2/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Call any function before start up
        config()
        
    }
    
    /// Function & Configuration
    private func config()
    {
        self.ShowDefaultNavigation()
    }
  
}
