//
//  ProfileNewController.swift
//  VSMS
//
//  Created by thou on 12/23/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileNewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    

    @IBOutlet weak var imgUser: CustomImage!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnLoan: UIButton!
    
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblLoan: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var segments: UISegmentedControl!
    
    var data = ["ringo","jule","miho","kohska","saw","petal"]
    // variable
    var ProfileHandleRequest = UserProfileRequestHandle()
    var index = 0
    var isPostActiveOrHistory = true
    var isLoadActiveOrHistory = true
    var isLoading = true
    var isHistoryLoading = true
    var isLikeLoading = true
    var isLoanActive = true
    var isLoanHistory = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !User.IsUserAuthorized() {
            PresentController.LogInandRegister()
        }
        InitailizeProfile()
        XibRegister()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        performOn(.Main) {
            //            self.ProfileHandleRequest.LoadProfileDetail {
            //                performOn(.Main, closure: {
            //                    self.InitailizeProfile()
            //                })
            //            }
            
            self.ProfileHandleRequest.LoadAllPostByUser {
                self.isLoading = false
                self.tableView.reloadData()
            }
            
            self.ProfileHandleRequest.LoadAllPostHistoryByUser {
                self.isHistoryLoading = false
                self.tableView.reloadData()
            }
            
            self.ProfileHandleRequest.LoadAllPostLikeByUser(completion: {
                self.isLikeLoading = false
                self.tableView.reloadData()
            })
            
            self.ProfileHandleRequest.LoadLoanActiveByUser {
                self.isLoanActive = false
                self.tableView.reloadData()
            }
            
            self.ProfileHandleRequest.LoadLoanHistoryByUser {
                self.isLoanHistory = false
                self.tableView.reloadData()
            }
        }
    }
    
    func InitailizeProfile(){

        let username = User.getUsername()
        lblPhone.text = username
        lblName.text = User.getfirstname() == "" ? User.getUsername() : User.getfirstname()
        
        imgUser.layer.cornerRadius = imgUser.frame.width * 0.5
        imgUser.clipsToBounds = true
        let userFir = Database.database().reference().child("users")
        userFir.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                for item in snapshot.children.allObjects as![DataSnapshot]{
                    let dictionary = item.value as? [String: String]
                    let userFir = dictionary?["username"]
                    if userFir == username
                    {
                        let imgurl = dictionary?["imageURL"]
                        if imgurl == "default"{
                            print("default")
                        }else {
                            self.imgUser.ImageLoadFromURL(url: imgurl ?? "")
                          
                        }
                    }
                }
            }
        }
        
        
    }

    @IBAction func onClickSetting(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onClick_Post(_ sender: UIButton) {
         tabActive(buttonActive: sender)
    }
    @IBAction func onClick_Like(_ sender: UIButton) {
         tabActive(buttonActive: sender)
    }
    @IBAction func onClick_Loan(_ sender: UIButton) {
         tabActive(buttonActive: sender)
    }
    
//    @IBAction func onSwitchChange(_ sender: Any) {
//        index = segments.selectedSegmentIndex
//        self.tableView.reloadData()
//    }
    
    func tabActive(buttonActive: UIButton)
    {
        switch buttonActive
        {
        case btnPost:
            index = 0
            self.tableView.reloadData()
            lblPost.isHidden = false
            lblLike.isHidden = true
            lblLoan.isHidden = true
        case btnLike:
            index = 1
            self.tableView.reloadData()
            lblPost.isHidden = true
            lblLike.isHidden = false
            lblLoan.isHidden = true
        case btnLoan:
            index = 2
            self.tableView.reloadData()
            lblPost.isHidden = true
            lblLike.isHidden = true
            lblLoan.isHidden = false
        default:
            break
        }
    }
    func XibRegister(){
        let posts = UINib(nibName: "PostsTableViewCell", bundle: nil)
        tableView.register(posts, forCellReuseIdentifier: "Postcell")
        
        let likes = UINib(nibName: "LikesTableViewCell", bundle: nil)
        tableView.register(likes, forCellReuseIdentifier: "likesCell")
        
        tableView.register(UINib(nibName: "ActiveDeactiveTableViewCell", bundle: nil), forCellReuseIdentifier: "activedeactiveCell")
        
        tableView.register(UINib(nibName: "LoanTableViewCell", bundle: nil), forCellReuseIdentifier: "LoanTableViewCell")
        
        tableView.register(UINib(nibName: "LoanHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "LoanHistoryTableViewCell")
        
        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if index == 0 {
            if indexPath.row == 0 {
                return 50
            }
            if !isPostActiveOrHistory{
                return 140
            }
            return 170
        }
        else if index == 1 {
            return 140
        }
        else {
            if indexPath.row == 0 {
                return 50
            }
            if isLoadActiveOrHistory{
                return 170
            }
            return 140
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 0
        {
            if isPostActiveOrHistory {
                if ProfileHandleRequest.PostActive.count == 0 {
                    return 2
                }
                return ProfileHandleRequest.PostActive.count + 1
            }
            else{
                if ProfileHandleRequest.PostHistory.count == 0 {
                    return 2
                }
                return ProfileHandleRequest.PostHistory.count + 1
            }
//            return data.count
        }
        else if index == 1
        {
            if ProfileHandleRequest.PostLike.count == 0
            {
                return 1
            }
            return ProfileHandleRequest.PostLike.count
//            return data.count
        }
        else
        {
            if isLoadActiveOrHistory
            {
                if ProfileHandleRequest.PostLoanActive.count == 0
                {
                    return 2
                }
                else{
                    return ProfileHandleRequest.PostLoanActive.count + 1
                }
            }
            else{
                if ProfileHandleRequest.PostLoanHistory.count == 0
                {
                    return 2
                }
                else{
                    return ProfileHandleRequest.PostLoanHistory.count + 1
                }
            }
//            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = data[indexPath.row]
//        return cell
        
            if index == 0
            {
                if indexPath.row == 0 {
                    let activeCell = tableView.dequeueReusableCell(withIdentifier: "activedeactiveCell", for: indexPath) as! ActiveDeactiveTableViewCell
                    
                    activeCell.sagement.selectedSegmentIndex = isPostActiveOrHistory ? 0 : 1
                    activeCell.sagementclick = { check in
                        self.isPostActiveOrHistory = check
                        self.tableView.reloadData()
                    }
                    return activeCell
                }
                if isPostActiveOrHistory
                {
                    if isLoading {
                        return tableView.loadingCell(Indexpath: indexPath)
                    }
                    
                    if ProfileHandleRequest.PostActive.count == 0 {
                        return tableView.noRecordCell(Indexpath: indexPath)
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Postcell", for: indexPath) as! PostsTableViewCell
                    cell.Data = ProfileHandleRequest.PostActive[indexPath.row - 1]
                    cell.reload()
//                    cell.delelgate = self
                    return cell
                }
                else{
                    if isHistoryLoading {
                        return tableView.loadingCell(Indexpath: indexPath)
                    }
                    
                    if ProfileHandleRequest.PostHistory.count == 0 {
                        return tableView.noRecordCell(Indexpath: indexPath)
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListTableViewCell
                    
                    cell.ProductData = ProfileHandleRequest.PostHistory[indexPath.row - 1]
//                    cell.delegate = self
                    cell.reload()
                    return cell
                    
                }
            }
            else if index == 1
            {
                if ProfileHandleRequest.PostLike.count == 0
                {
                    if isLikeLoading {
                        return tableView.loadingCell(Indexpath: indexPath)
                    }
                    
                    return tableView.noRecordCell(Indexpath: indexPath)
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "likesCell", for: indexPath) as! LikesTableViewCell
                cell.ProductData = ProfileHandleRequest.PostLike[indexPath.row]
//                cell.delegate = self
//                cell.DeleteHandle = { ProID in
//                    self.DeleteUnlike(ProID: ProID)
//                    self.tableView.reloadData()
//                }
                cell.reload()
                return cell
            }
            else
            {
                if indexPath.row == 0 {
                    let activeCell = tableView.dequeueReusableCell(withIdentifier: "activedeactiveCell", for: indexPath) as! ActiveDeactiveTableViewCell
                    
                    activeCell.sagement.selectedSegmentIndex = isLoadActiveOrHistory ? 0 : 1
                    activeCell.sagementclick = { check in
                        self.isLoadActiveOrHistory = check
                        self.tableView.reloadData()
                    }
                    return activeCell
                }
                
                if isLoadActiveOrHistory
                {
                    if isLoanActive {
                        return tableView.loadingCell(Indexpath: indexPath)
                    }
                    
                    if ProfileHandleRequest.PostLoanActive.count == 0
                    {
                        return tableView.noRecordCell(Indexpath: indexPath)
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoanTableViewCell", for: indexPath) as! LoanTableViewCell
                    let data = ProfileHandleRequest.PostLoanActive[indexPath.row - 1]
                    cell.LoanID = data.id
                    cell.ProductID = data.post
                    cell.ReloadXib()
                    
//                    cell.DeleteHandle = { loanID in
//                        self.DeleteLoanHandler(LoanID: loanID)
//                    }
//
//                    cell.DetailHandle = { loanID in
//                        self.DetailLoanHandler(LoanID: loanID)
//                    }
//
//                    cell.EditHandle = { loanID in
//                        self.EditLoanHandler(LoanID: loanID)
//                    }
                    
                    return cell
                }
                else{
                    if isLoanHistory {
                        return tableView.loadingCell(Indexpath: indexPath)
                    }
                    
                    if ProfileHandleRequest.PostLoanHistory.count == 0
                    {
                        return tableView.noRecordCell(Indexpath: indexPath)
                    }
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoanHistoryTableViewCell", for: indexPath) as! LoanHistoryTableViewCell
                    let data = ProfileHandleRequest.PostLoanHistory[indexPath.row - 1]
                    cell.LoanID = data.id
                    cell.ProductID = data.post
                    cell.reloadXib()
                    return cell
                }
            }
        }
    
}

