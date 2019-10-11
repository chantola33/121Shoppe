//
//  FilterBottonViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/24/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class FilterBottonViewController: UIViewController {
    
    let check = UIImage(named: "ic_radio_button_checked_white")
    let uncheck = UIImage(named: "ic_radio_button_unchecked_white")
    
    var selectedIndex: Int?
    var link: BtnFilter?
    var labelData: FilterButtonEnum?
    var all: String = ""
    var Category: String = ""
    var Brand: String = ""
    var Years: String = ""
    var Prices: String = ""
    
    
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        //function
        RegisterXib()
        lblList.text = labelData?.description
    }
    @IBAction func back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func RegisterXib(){
        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
    }
    
}

extension FilterBottonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelData?.rowRowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            print("1")
        case 1:
            print("2")
        case 2:
            print("3")
        default:
            print("default")
        }
       
        
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! BtnFilter
        
        if(indexPath.row == selectedIndex)
        {
            cell.img.image = check
        }
        else
        {
            cell.img.image = uncheck
        }
        return cell
    }
    
}



class BtnFilter: UITableViewCell{
    
    @IBOutlet weak var img: UIImageView!
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


