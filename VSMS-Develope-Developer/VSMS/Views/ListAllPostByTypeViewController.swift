//
//  ListAllPostByTypeViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/19/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import SideMenuSwift

class ListAllPostByTypeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var parameter = RelatedFilter()
    var categoryArr: [dropdownData] = []
    var iconArr: [UIImage] = [UIImage(named: "electronicIcon")!,
                              UIImage(named: "motoIcon")!,
                              UIImage(named: "homeIcon")!]
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.hidesBottomBarWhenPushed = true
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        Configuration()
        LoadCategory()
        ShowDefaultNavigation()
    }
    
    func Configuration() {
        self.navigationItem.title = self.parameter.type.capitalizingFirstLetter()
        self.hidesBottomBarWhenPushed = true
        
        tableView.register(UINib(nibName: "ListCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCategoryCell")
    }
    
    func LoadCategory(){
        Functions.getDropDownList(key: 2) { (val) in
            self.categoryArr = val
            self.tableView.reloadData()
        }
    }
}

extension ListAllPostByTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCategoryCell", for: indexPath) as! ListCategoryTableViewCell
        cell.lblText.text = categoryArr[indexPath.row].Text
        cell.imgIcon.image = iconArr[indexPath.row]
        cell.categoryID = categoryArr[indexPath.row].ID
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ListAllPostByTypeViewController: CellClickProtocol {
    func cellXibClick(ID: Int) {
        self.parameter.category = ID.toString()
        
        let listVC = ListAllProductViewController()
        listVC.paramater = self.parameter
        self.navigationController?.pushViewController(listVC, animated: true)
        
    }
}
