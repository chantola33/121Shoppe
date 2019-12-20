//
//  Alert.swift
//  VSMS
//
//  Created by thou on 12/16/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Foundation
class AlertDialog: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Popupview: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    
    var name: [String] = ["Motorbike","Electronic","Car","train","Boat","Airplan","Bikecycle","Airconditioner","TV"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Shared.shared.companyName = name[indexPath.row]
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchFilterController") as! SearchFilterController
         self.present(newViewController, animated: true, completion: nil)

    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = name[indexPath.row]
        return cell
    }
    
}

