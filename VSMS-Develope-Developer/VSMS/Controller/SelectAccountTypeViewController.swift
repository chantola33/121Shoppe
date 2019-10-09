//
//  SelectAccountTypeViewController.swift
//  VSMS
//
//  Created by usah on 10/9/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class SelectAccountTypeViewController: UIViewController {

    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnDealer: UIButton!
    var user_group = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPublicAction(_ sender: Any) {
        if btnDealer.isSelected {
            btnDealer.isSelected = false
            btnPublic.isSelected = true
        }else {
            btnPublic.isSelected = true
        }
       user_group = 1
        print("\(String(describing: user_group))")
    }
    
   
    @IBAction func btnDealerAction(_ sender: Any) {
        if btnPublic.isSelected {
            btnPublic.isSelected = false
            btnDealer.isSelected = true
        }else {
            btnDealer.isSelected = true
        }
        user_group = 3
        print(user_group)
    }
    @IBAction func btnNextAction(_ sender: Any) {
        print("next")
//         let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
//        menuViewController.user_group = user_group
//        self.present(menuViewController, animated: true, completion: nil)
        if self.user_group == 0 {
            Message.AlertMessage(message: "Please Select Account Type.", header: "Warning", View: self, callback: {
                return
            })
            return
        }
        let menuViewController: RegisterController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
        menuViewController.user_group = user_group
        self.navigationController?.pushViewController(menuViewController, animated: true)
    }
}
