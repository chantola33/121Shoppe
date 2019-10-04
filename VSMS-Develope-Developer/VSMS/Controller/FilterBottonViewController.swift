//
//  FilterBottonViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/24/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class FilterBottonViewController: UIViewController {
    
    
    var labelData: FilterButtonEnum?
   
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        //function
        
        lblList.text = labelData?.description
    }
    @IBAction func back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
}

extension FilterBottonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelData?.rowRowCount ?? 0
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NameType
        let row = indexPath.row
       
        if row == 0 {
            cell.lblName.text = "All"
            cell.btnClick.setImage(UIImage(named: "ic_radio_button_checked_white"), for:.normal)
            cell.btnClick.addTarget(self, action: #selector(methodname), for: .touchUpInside)
        }else if row == 1 {
            cell.lblName.text = "Sale"
            cell.btnClick.setImage(UIImage(named: "ic_radio_button_unchecked_white"), for:.normal)
            cell.btnClick.addTarget(self, action: #selector(methodname), for: .touchUpInside)
        }else {
            cell.lblName.text = "Rent"
            cell.btnClick.setImage(UIImage(named: "ic_radio_button_unchecked_white"), for:.normal)
            cell.btnClick.addTarget(self, action: #selector(methodname), for: .touchUpInside)
        }
      
       // cell.lblName.text = "tesing"
        return cell
    }
    
   
    
    @objc func methodname()
    {
       print("Click")
    }
}


class NameType: UITableViewCell{
    @IBOutlet weak var btnClick: UIButton!
    @IBOutlet weak var lblName: UILabel!
}

enum FilterButtonEnum:Int, CustomStringConvertible {
    case allPost
    case category
    case brand
    case year
    case price

    var description: String {
        switch self {
        case .allPost:
            return "All Post"
        case .category:
            return "Category"
        case .brand:
            return "Brand"
        case .year:
            return "Year"
        case .price:
            return "Price"
        }
    }
        
        var rowRowCount: Int {
            switch self {
            case .allPost:
                return 3
            case .category:
               return 2
            case .brand:
                return 5
            case .year:
                return 10
            case .price:
                return 5
            }
            //return 3
        }
}


