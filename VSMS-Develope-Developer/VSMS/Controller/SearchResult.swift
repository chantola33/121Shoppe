//
//  SearchTesting.swift
//  VSMS
//
//  Created by usah on 12/11/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit
class SearchResult: UIViewController ,  UITableViewDelegate , UITableViewDataSource{

   
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var search_title = ""
    var post_type = ""
    var category = ""
    var year = ""
    
    var parameter = SearchFilter()
    var resultArr: [HomePageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Filter: " + search_title + category + year)
        sbSearch.text = search_title
        parameter.search = search_title
        parameter.category = category
        parameter.year = year
        
        configuration()
        SearchHandle()
    }
    
    func configuration(){
        
        self.navigationItem.title = "Search"
        self.tabBarController?.tabBar.isHidden = true
        
        sbSearch.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        sbSearch.text = parameter.search
        
        //Register xib
        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        
    }
    func SearchHandle() {
        RequestHandle.SearchProduct(filter: self.parameter ) { (val) in
            self.resultArr = val
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellsearch", for: indexPath) as! SearchListTableView
//        cell.lblProName.text = resultArr[indexPath.row].post_sub_title
        cell.ProductData = resultArr[indexPath.row]
        cell.delegate = self
        cell.reload()
        return cell
        
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }
    
}
extension SearchResult: CellClickProtocol {
    func cellXibClick(ID: Int) {
        self.PushToDetailProductViewController(productID: ID)
    }
}
extension SearchResult: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.sbSearch.endEditing(false)
        self.parameter.search = searchBar.text ?? ""
        self.parameter.category = category
        self.parameter.year = year
        self.SearchHandle()
    }
}
