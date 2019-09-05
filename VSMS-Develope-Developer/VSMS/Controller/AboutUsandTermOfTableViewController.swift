//
//  AboutUsandTermofprivancyTableViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/11/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class AboutUsandTermOfTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var listType = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "AboutUsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "AboutUs")
        tableView.register(UINib(nibName: "TermofprivacyTableViewCell",bundle: nil),
                           forCellReuseIdentifier: "Termofprivacy")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listType == "About Us" {
            return 468
        }else if listType == "Term of Privacy" {
            return 1300
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUs")
//                    as! AboutUsTableViewCell
//                   return cell
        if listType == "About Us" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUs")
                as! AboutUsTableViewCell
            return cell
        }else if listType == "Term of Privacy" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Termofprivacy")
                as! TermofprivacyTableViewCell
            return cell
        }
     return UITableViewCell()
    }

   
}
