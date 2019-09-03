//
//  ListAllProductViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/19/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ListAllProductViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var paramater: RelatedFilter?
    var dataArr: [HomePageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        
        performOn(.Main) {
            RequestHandle.LoadAllPostByPostTypeAndCategory(filter: self.paramater!, completion: { (val) in
                self.dataArr = val
                self.tableView.reloadData()
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
    }
    
}

extension ListAllProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListTableViewCell
        let data = dataArr[indexPath.row]
        cell.ProductData = data
        cell.reload()
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}

extension ListAllProductViewController: CellClickProtocol {
    func cellXibClick(ID: Int) {
       self.PushToDetailProductViewController(productID: ID)
    }
}
