//
//  MenuViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 6/24/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SideMenuSwift
class MenuViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imageprofile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: leftMenuClick?
    
    override func localizeUI(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageprofile.layer.cornerRadius = imageprofile.frame.width * 0.5
        imageprofile.clipsToBounds = true
        
        tableView.reloadData()
        imageprofile.CirleWithWhiteBorder(thickness: 1)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        lblProfileName.text = User.getfirstname() == "" ? User.getUsername() : User.getfirstname()
        
        UserFireBase.Load { (user) in
            if user.imageURL != "" {
                self.imageprofile.ImageLoadFromURL(url: user.imageURL)
            }
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblProfileName.text = User.getfirstname() == "" ? User.getUsername() : User.getfirstname()
        //self.tabBarController?.tabBar.isHidden = false
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            self.delegate?.cellClick(list: "profile")
        case 1:
            self.delegate?.cellClick(list: "Your Post")
        case 2:
            self.delegate?.cellClick(list: "Your Like")
        case 3:
            self.delegate?.cellClick(list: "Your Loan")
            //self.delegate?.cellClick(list: "share")
        case 4:
             self.delegate?.cellClick(list: "Setting")
        case 5:
             self.delegate?.cellClick(list: "About 121")
        case 6:
            self.delegate?.cellClick(list: "Contact 121")
        case 7:
             self.delegate?.cellClick(list: "Term of Privacy")
        default:
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SectionMenu
        let row = indexPath.row
        
        if row == 0{
            cell.titleLabel.text = "yourprofile".localizable()
        } else if row == 1 {
            cell.titleLabel.text = "yourposts".localizable()
        } else if row == 2 {
            cell.titleLabel.text = "yourlike".localizable()
        } else if row == 3 {
            cell.titleLabel.text = "yourloan".localizable()
        } else if row == 4 {
            cell.titleLabel.text = "setting".localizable()
        } else if row == 5 {
            cell.titleLabel.text = "aboutus".localizable()
        } else if row == 6 {
            cell.titleLabel.text = "Contact 121"
        } else if row == 7 {
            cell.titleLabel.text = "termofprivancy".localizable()
        } else{
        }
        return cell
    }
    
    
    
}

class SectionMenu: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
}

