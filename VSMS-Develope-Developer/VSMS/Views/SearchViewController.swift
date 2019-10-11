//
//  SearchViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/20/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var txtSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Internal Properties
    var parameter = SearchFilter()
    var resultArr: [HomePageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
       // SearchHandle()
    }
    
    
    ///functions & Selectors
    func configuration(){
        
        self.navigationItem.title = "Search"
        self.tabBarController?.tabBar.isHidden = true
        
        txtSearchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        txtSearchBar.text = parameter.search
        
        //Register xib
        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")

    }
    
//    func SearchHandle(){
//        if parameter.brand == "" {
//            RequestHandle.SearchProduct(filter: self.parameter) { (val) in
//                self.resultArr = val
//                self.tableView.reloadData()
//            }
//        }
//        else {
//            for model in parameter.modelings {
//                self.parameter.model = model
//                RequestHandle.SearchProduct(filter: self.parameter) { (val) in
//                    self.resultArr += val
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.txtSearchBar.endEditing(false)
        
        self.parameter.search = searchBar.text ?? ""
      //  self.SearchHandle()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListTableViewCell
        cell.ProductData = resultArr[indexPath.row]
        cell.delegate = self
        cell.reload()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}

extension SearchViewController: CellClickProtocol {
    func cellXibClick(ID: Int) {
        self.PushToDetailProductViewController(productID: ID)
    }
}
