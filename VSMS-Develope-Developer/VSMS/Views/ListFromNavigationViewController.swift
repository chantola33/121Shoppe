//
//  ListFromNavigationViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/20/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ListFromNavigationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listType = ""
    var dataArr: [HomePageModel] = []
    var postIDArr: [String] = []
    var index = 0
    var tabActive = 0
    var btnMenu = false
  
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShowDefaultNavigation()
        self.navigationItem.title = listType

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        
        if listType == "Your Post" {
//            RequestHandle.LoadAllPostByUser { (val) in
//                self.dataArr = val
//                self.tableView.reloadData()
//            }
            if let currentView = UIApplication.topViewController() {
                index = 0
                let ProfileTab: UINavigationController = {
                    let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                    profile.index = index
                    return UINavigationController(rootViewController: profile)
                }()
                ProfileTab.modalPresentationStyle = .fullScreen
                currentView.present(ProfileTab, animated: false, completion: nil)
            }
        }
        else if listType == "Your Like" {
            if let currentView = UIApplication.topViewController() {
                index = 1
                tabActive = 2
                let ProfileTab: UINavigationController = {
                    let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                    profile.index = index
                    profile.tabActive = tabActive
                    
                    return UINavigationController(rootViewController: profile)
                }()
                ProfileTab.modalPresentationStyle = .fullScreen
                currentView.present(ProfileTab, animated: false, completion: nil)
            }
//            performOn(.HighPriority) {
//                RequestHandle.LoadAllPostLikeByUser { (val) in
//                    self.postIDArr = val
//
//                    performOn(.Main, closure: {
//                        for post in self.postIDArr {
//                            RequestHandle.LoadListProductByPostID(postID: post.toInt(), completion: { (val) in
//                                print(post)
//                                self.dataArr.append(val)
//                                self.tableView.reloadData()
//                            })
//                        }
//                    })
//
//                }
//            }
        }
//        else if listType == "Your Loan" {
//            if let currentView = UIApplication.topViewController() {
//                index = 2
//                tabActive = 3
//                let ProfileTab: UINavigationController = {
//                    let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
//                    profile.index = index
//                    profile.tabActive = tabActive
//                    return UINavigationController(rootViewController: profile)
//                }()
//                ProfileTab.modalPresentationStyle = .fullScreen
//                currentView.present(ProfileTab, animated: false, completion: nil)
//            }
//        }
     }
}

extension ListFromNavigationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListTableViewCell
        
        cell.ProductData = dataArr[indexPath.row]
        cell.reload()
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
}

extension ListFromNavigationViewController: CellClickProtocol {
    func cellXibClick(ID: Int) {
        self.PushToDetailProductByUserViewController(productID: ID)
    }
}
