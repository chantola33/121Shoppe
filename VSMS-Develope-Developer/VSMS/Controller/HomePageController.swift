//
//  HomeController.swift
//  VSMS
//
//  Created by Rathana on 3/13/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SideMenuSwift
import RSSelectionMenu

class MyNavigation: UINavigationController, leftMenuClick {
    
    weak var menuDelegate: navigationToHomepage?
    
    func cellClick(list: String) {
        menuDelegate?.menuClick(list: list)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rootVC:HomePageController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageController") as! HomePageController
        
        self.menuDelegate = rootVC
        self.viewControllers = [rootVC]
    }
}


class HomePageController: BaseViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ButtonFilterCollection: UICollectionView!
    @IBOutlet weak var SliderCollection: UICollectionView!
    @IBOutlet weak var DiscountCollection: UICollectionView!
    @IBOutlet weak var btnImag: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var lblNewpost: UILabel!
    @IBOutlet weak var lblbestDeal: UILabel!
    @IBOutlet weak var BtnCollection: UICollectionView!
    
    
    
//    @IBOutlet weak var txtSearch: UISearchBar!
   
    
    
    var KhmerFlatButton: UIBarButtonItem!
    var EnglishFlatButton: UIBarButtonItem!
    
    
    var AL = HomepageRequestHandler()
    var imgArr = [  UIImage(named:"Dream191"),
                    UIImage(named:"Dream192"),
                    UIImage(named:"Dream193")]
    var buttonFilter = ["All Post","Category","Brand","Years","Prices"]
    
    
    var timer = Timer()
    var counter = 0
    var CellIdentifier = 3
    var IndexProduct = -1
    var ProductDetail = DetailViewModel()
    var searchFilter = SearchFilter()
    
    var bestDealArr: [HomePageModel] = []
    var allPostArr: [HomePageModel] = []
    
 
    var categories: [String] = []
    var categoryRawData: [dropdownData] = []

    var brands: [String] = []
    var brandRawData: [dropdownData] = []
    var brandSubRawData: [dropdownData] = []

    var years: [String] = []
    var yearRawData: [dropdownData] = []
    var modelsArr: [dropdownData] = []
    
    let now = Date()
    let pastDate = Date(timeIntervalSinceNow: -60 * 62)
    
    
    override func localizeUI() {
        self.Prepare()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Prepare()

        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        
        
        configuration()
        setupNavigationBarItem()
        ShowDefaultNavigation()
        RegisterXib()
        SlidingPhoto()
        if UserDefaults.standard.string(forKey: currentLangKey) == "en"{
            navigationItem.rightBarButtonItem = KhmerFlatButton
        }else{
            navigationItem.rightBarButtonItem = EnglishFlatButton
        }
        performOn(.Main) {
            RequestHandle.LoadBestDeal(completion: { (val) in
                self.bestDealArr = val
                self.DiscountCollection.reloadData()
            })
        }
        
        performOn(.Main) {
            self.AL.LoadAllPosts(completion: {
                self.tableView.reloadData()
            })
        }
        
        performOn(.Background) {
            Functions.getDropDownList(key: 5, completion: { (val) in
                self.modelsArr = val
            })
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.sideMenuController?.delegate = self
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func imgClick(_ sender: Any) {
        refrestButtonFilter(type: 1)
    }
    @IBAction func gridClick(_ sender: Any) {
        refrestButtonFilter(type: 2)
    }
    @IBAction func listClick(_ sender: Any) {
        refrestButtonFilter(type: 3)
    }
    
    
//    @IBAction func Searchclick(_ sender: Any) {
//        let searchVC = SearchViewController()
//        searchVC.parameter = self.searchFilter
//        self.navigationController?.pushViewController(searchVC, animated: true)
//    }
    
    
    ///////////////////functions & Selectors
    func configuration(){
        SliderCollection.delegate = self
        SliderCollection.dataSource = self
        
        DiscountCollection.delegate = self
        DiscountCollection.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Button Filter
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        
        filterLayout.minimumLineSpacing = 0
        filterLayout.itemSize = CGSize(width: (self.ButtonFilterCollection.frame.width / 4), height: self.ButtonFilterCollection.frame.height)
        filterLayout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        ButtonFilterCollection.collectionViewLayout = filterLayout
        ButtonFilterCollection.showsHorizontalScrollIndicator = false
        //config best deal flow layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (self.DiscountCollection.frame.width / 2) - 20, height: self.DiscountCollection.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        DiscountCollection.collectionViewLayout = layout
        
    }
    
    func refrestButtonFilter(type: Int) {
        switch type {
        case 1:
            btnImag.setImage(UIImage(named:"img_active"), for: .normal)
            btnGrid.setImage(UIImage(named:"thumnail"), for: .normal)
            btnList.setImage(UIImage(named:"list"), for: .normal)
            self.CellIdentifier = type
            self.tableView.reloadData()
        case 2:
            btnImag.setImage(UIImage(named:"img"), for: .normal)
            btnGrid.setImage(UIImage(named:"thumnail_active"), for: .normal)
            btnList.setImage(UIImage(named:"list"), for: .normal)
            self.CellIdentifier = type
            self.tableView.reloadData()
        case 3:
            btnImag.setImage(UIImage(named:"img"), for: .normal)
            btnGrid.setImage(UIImage(named:"thumnail"), for: .normal)
            btnList.setImage(UIImage(named:"list_active"), for: .normal)
            self.CellIdentifier = type
            self.tableView.reloadData()
        default: break
        }
    }
    
//    @objc
//    func btnPostTypeHandler(_ sender: UIButton){
//        switch sender {
//        case btnBuy:
//            let buyVC = ListAllPostByTypeViewController()
//            buyVC.parameter.type = "buy"
//            self.navigationController?.pushViewController(buyVC, animated: true)
//        case btnRent:
//            let buyVC = ListAllPostByTypeViewController()
//            buyVC.parameter.type = "rent"
//            self.navigationController?.pushViewController(buyVC, animated: true)
//        case btnSell:
//            let buyVC = ListAllPostByTypeViewController()
//            buyVC.parameter.type = "sell"
//            self.navigationController?.pushViewController(buyVC, animated: true)
//        default:
//            print("default")
//        }
//    }
    
    @objc
    func btnswicthLanguage(_ sender: UIButton){
        
        if UserDefaults.standard.string(forKey: currentLangKey) == "en"
        {
            LanguageManager.setLanguage(lang: .khmer)
            self.navigationItem.rightBarButtonItem = EnglishFlatButton //KhmerFlatButton
            
        }
        else{
            LanguageManager.setLanguage(lang: .english)
            self.navigationItem.rightBarButtonItem = KhmerFlatButton //EnglishFlatButton
        }
    }
    
    @objc func menutap() {
        if User.IsUserAuthorized() {
            self.viewDidAppear(true)
            // self.tabBarController?.tabBar.isHidden = true
            sideMenuController?.revealMenu()
        }
    }
    
    @objc func changeImage() {
        if counter < imgArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.SliderCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.SliderCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
           
            counter = 1
        }
    }
    
    func RegisterXib(){
        let imagehomepage = UINib(nibName: "DiscountCollectionViewCell", bundle: nil)
        DiscountCollection.register(imagehomepage, forCellWithReuseIdentifier: "imgediscount")
        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        tableView.register(UINib(nibName: "ProductImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductImageCell")
        tableView.register(UINib(nibName: "ProductGridTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductGridCell")
         ButtonFilterCollection.register(UINib(nibName: "BtnFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BtnFilterCollectionViewCell")
    }
    
    func SlidingPhoto(){
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "HamburgarIcon"), style: .done, target: self, action: #selector(menutap))
        self.navigationItem.leftBarButtonItem = menuBarButton
    }
    
    private func setupNavigationBarItem() {
        
        let logo = UIImage(named: "HamburgarIcon")
        let menu = UIButton(type: .system)
        menu.setImage(logo, for: .normal)
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menu)
        menu.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        //menu.tintColor = UIColor.lightGray
        
        //logo
        let menubutton = UIBarButtonItem(customView: menu)
        let logoImage = UIImage.init(named: "121logo")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x:0, y: 0, width: 0, height: 0)
        logoImageView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        //   (-40, 0, 150, 25)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        navigationItem.leftBarButtonItems = [menubutton, imageItem]
        
        
        //set image for button
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "flatenglish"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        button.addTarget(self, action: #selector(btnswicthLanguage(_:)), for: .touchUpInside)
        EnglishFlatButton = UIBarButtonItem(customView: button)
        
        let buttonKH = UIButton(type: .custom)
        buttonKH.setImage(UIImage(named: "flatkhmer"), for: .normal)
        buttonKH.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        buttonKH.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonKH.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        buttonKH.addTarget(self, action: #selector(btnswicthLanguage(_:)), for: .touchUpInside)
        KhmerFlatButton = UIBarButtonItem(customView: buttonKH)
        //assign button to navigationbar
        
        if UserDefaults.standard.string(forKey: currentLangKey) == "en"
        {
            self.navigationItem.rightBarButtonItem = EnglishFlatButton
        }
        else{
            self.navigationItem.rightBarButtonItem = KhmerFlatButton
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DetailVC = segue.destination as? DetailViewController {
            DetailVC.ProductDetail = self.ProductDetail
        }
    }
    
}

extension HomePageController
{
    func Prepare()
    {
        lblbestDeal.text = "bestdeal".localizable()
        lblNewpost.text = "newpost".localizable()
    }
    
    func handleFilterClick(btnIndex: Int)
    {
        ShowCategoryOption()
    }
    
    func ShowCategoryOption()
    {
        let selectionMenu = RSSelectionMenu<Any>(dataSource: ["Data1", "Data2"])
        { (cell, item, indexPath) in
            cell.textLabel?.text = item as? String
        }
        
        selectionMenu.setSelectedItems(items: [])
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.tableView.reloadData()
        }
        
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .actionSheet(title: "Category", action: nil, height: nil), from: self)
    }
    
}
    
extension HomePageController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == SliderCollection {
            return imgArr.count
        }
        else if collectionView == ButtonFilterCollection {
            return buttonFilter.count
        }
        else {
            return bestDealArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == SliderCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                vc.image = imgArr[indexPath.row]
            }
            return cell
        }
        else if collectionView == ButtonFilterCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BtnFilterCollectionViewCell", for: indexPath)  as! BtnFilterCollectionViewCell
            cell.btnFilter.titleString = buttonFilter[indexPath.row]
            cell.indexButton = indexPath.row
            cell.clickRespone = { index in
                self.handleFilterClick(btnIndex: index)
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgediscount", for: indexPath) as! DiscountCollectionViewCell
            cell.data = bestDealArr[indexPath.row]
            cell.delegate = self
            cell.reload()
            return cell
        }
    }
    

  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == DiscountCollection
        {
            return CGSize(width: (self.view.frame.width / 2) - 8, height: collectionView.frame.height)
        }
        else if collectionView == ButtonFilterCollection {
            return CGSize(width: (self.view.frame.width / 4) - 8, height: collectionView.frame.height)
        }
        else {
            return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension HomePageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CellIdentifier == 2 {
            IndexProduct = -1
            if AL.AllPostArr.count % 2 != 0
            {
                return (AL.AllPostArr.count / 2) + 1
            }
            
            return AL.AllPostArr.count / 2
        }
        return AL.AllPostArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = AL.AllPostArr[indexPath.row]
        
        if CellIdentifier == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductImageCell", for: indexPath) as! ProductImageTableViewCell
            
            cell.data = data
            cell.delegate = self
            return cell
        }
        else if CellIdentifier == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductGridCell", for: indexPath) as! ProductGridTableViewCell
            
            let index = indexPath.row * 2
            cell.data1 = AL.AllPostArr[index]
            
            if let d2 = AL.AllPostArr.get(at: index + 1){
                cell.data2 = d2
            }
            
            cell.delegate = self
            cell.reload()

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListTableViewCell
            
            cell.ProductData = data
            cell.delegate = self
            cell.reload()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if CellIdentifier == 1 {
            return 350
        }
        else if CellIdentifier == 2 {
            return 220
        }
        else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = AL.AllPostArr.count - 5
        if indexPath.row == lastIndex {
            AL.LoadAllPostsNextPage {
                self.tableView.reloadData()
            }
        }
    }
}

extension HomePageController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        view.frame = UIScreen.main.bounds
    }

    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        view.frame = UIScreen.main.bounds
    }
    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        view.frame = UIScreen.main.bounds
    }
    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        view.frame = UIScreen.main.bounds
    }
    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        view.frame = UIScreen.main.bounds
    }
}

extension HomePageController : CellClickProtocol {
    func cellXibClick(ID: Int) {
        PushToDetailProductViewController(productID: ID)
    }
}

extension HomePageController: navigationToHomepage {
    func menuClick(list: String) {
        sideMenuController?.hideMenu()
        switch list {
        case "profile":
            let profileVC: MyAccountController = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountController") as! MyAccountController
            self.navigationController?.pushViewController(profileVC, animated: true)
           // self.present(navi, animated: false,completion: nil)
        case "Setting":
            let settingVC: SettingTableController =
                self.storyboard?.instantiateViewController(withIdentifier: "SettingTableController") as! SettingTableController
           // let navi = UINavigationController(rootViewController: settingVC)
            self.navigationController?.pushViewController(settingVC, animated: true)
        case "About Us":
            let about_usVC: AboutUsandTermOfTableViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "AboutUsandTermOfTableViewController") as! AboutUsandTermOfTableViewController
            about_usVC.listType = "About Us"
            self.navigationController?.pushViewController(about_usVC, animated: true)
        case "Term of Privacy":
            let termof: AboutUsandTermOfTableViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "AboutUsandTermOfTableViewController") as!
            AboutUsandTermOfTableViewController
            termof.listType = "Term of Privacy"
            self.navigationController?.pushViewController(termof, animated: true)
        break
        default:
            let listVC = ListFromNavigationViewController()
            listVC.listType = list
            self.navigationController?.pushViewController(listVC, animated: true)
        }
    }
}


class SectionCell: UICollectionViewCell
{
    @IBOutlet weak var btnAllpost: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnBrand: UIButton!
    @IBOutlet weak var btnYears: UIButton!
    @IBOutlet weak var btnPrices: UIButton!
}



