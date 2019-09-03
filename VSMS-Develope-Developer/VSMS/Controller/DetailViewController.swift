//
//  DetailViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/12/19.
//  Copyright © 2019 121. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import GoogleMaps
import MapKit



class DetailViewController: UIViewController {
    
    //Internal Properties
    var ProductID:Int = -1
    var ProductDetail = DetailViewModel()
    var timer = Timer()
    var counter = 0
    var relateArr: [HomePageModel] = []
    var userdetail: Profile?
    var isLikeEnable = false
    var condtionlike = false
    
    //mapUser
   
    
    
    //Master Propertise
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var CollectView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnLike: BottomDetail!
    
    
    //IBOutlet Propeties
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblUserPhoneNumber: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var txtTerm: UITextField!
    @IBOutlet weak var txtdeposit: UITextField!
    @IBOutlet weak var txtinterestRate: UITextField!
    @IBOutlet weak var txtprice: UITextField!
    
    @IBOutlet weak var LoanView: UIView!
    @IBOutlet weak var lblmonthlypayment: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imgProfilePic.addGestureRecognizer(tap)
        imgProfilePic.isUserInteractionEnabled = true
        txtinterestRate.text = "1.5"
        txtTerm.text = "1"
        
        
        txtTerm.bordercolor()
        txtinterestRate.bordercolor()
        txtdeposit.bordercolor()
        txtprice.bordercolor()
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.width * 0.5
        // Do any additional setup after loading the view.
        config()
        ImageSlideConfig()
        InitailDetail()
        LoadUserDetail()
        XibRegister()
        map()
        tblView.reloadData()
        tblView.delegate = self
        tblView.dataSource = self
        
        performOn(.Main) {
            RequestHandle.LoadRelated(postType: self.ProductDetail.post_type,
                                      category: self.ProductDetail.category.toString(),
                                      modeling: self.ProductDetail.modeling.toString(),
                                      completion: { (val) in
                                        self.relateArr = val
                                        self.tblView.reloadData()
            })
            
            RequestHandle.Conditionlike(ProID: self.ProductDetail.id.toString(),
                                        UserID: User.getUserID().toString(),
                                        completion: { (val) in
                                            self.condtionlike = val
            })
            
            
        }
        
        txtprice.addTarget(self, action: #selector(CalculatorLoan), for: UIControl.Event.editingChanged)
        txtinterestRate.addTarget(self, action: #selector(CalculatorLoan), for: UIControl.Event.editingChanged)
        txtTerm.addTarget(self, action: #selector(CalculatorLoan), for: UIControl.Event.editingChanged)
        
//        if(ProductDetail.post_type == "sell"){
//            LoanView.isHidden = true
//
//        }
        
//        ProductDetail.post_type = "rent"
//        ProductDetail.post_type = "buy"
//        ProductDetail.post_type = "sell"
    }
    
    
    func map(){
        
        let location = CLLocation(latitude: 11.562108, longitude: 104.888535)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?){
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            lblAddress.text = "Unable to Find Address for Location"
        }else{
            if let placemarks = placemarks, let placemark = placemarks.first{
                lblAddress.text = "Address: \(placemark.compactAddrss ?? "")"
            }else{
                lblAddress.text = "No Maching Address Found"
            }
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContectViewController") as! ContectViewController
        vc.UserPostID = ProductDetail.created_by
        vc.userdetail = self.userdetail

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //Events Handler
    @IBAction func clickCall(_ sender: Any) {
        makeAPhoneCall(phoneNumber: self.ProductDetail.contact_phone)
    }
    
    @IBAction func clickSms(_ sender: Any) {
        let chatdata = MessageViewModel()
        chatdata.username = userdetail?.PhoneNumber
        chatdata.proImage = ProductDetail.front_image_url
        chatdata.proName = ProductDetail.title
        chatdata.proPrice = ProductDetail.cost
        PresentController.PushToMessageViewController(from: self, chatData: chatdata)
    }
    
    @IBAction func clickLike(_ sender: Any) {
        
        if condtionlike == true {
            Message.AlertMessage(message: "You have like this product already.", header: "LIKE", View: self){}
        }
        else
        {
            Message.AlertMessage(message: "Like Successful.", header: "LIKE", View: self){
                self.Btnlikebyuser()
                self.condtionlike = true
                self.tblView.reloadData()
            }
        }

}
    
    
    @IBAction func clickLoan(_ sender: Any) {
        let loanVC:LoanViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoanViewController") as! LoanViewController
        loanVC.Loan.loan_to = ProductDetail.created_by
        loanVC.Loan.post = ProductDetail.id
        self.navigationController?.pushViewController(loanVC, animated: true)
    }
    
    
    //Function and Selector
    
    @objc
    func CalculatorLoan(){
        let Year = txtTerm.text?.toDouble() ?? 1
        let SalePrice = txtprice.text?.toDouble() ?? 0
        let rate = txtinterestRate.text?.toDouble() ?? 0
  
        let MonthCount = Year
        let interate = rate / 100
        let PowValue = pow((1 + interate), -(MonthCount))
        let UnderValue = (1 - PowValue) / interate
        let result = SalePrice / UnderValue
        
        if (txtprice.text == "") && (txtTerm.text == "") {
            lblmonthlypayment.text = " $0.00"
        }else{
         lblmonthlypayment.text = "\(result)".toCurrency()
        }
    }
    
    func Btnlikebyuser(){
        
        let data: Parameters = [
            "post": ProductDetail.id,
            "like_by": User.getUserID(),
            "record_status": 1,
            ]
        let headers = [
            "Cookie": "",
            "Accept": "application/json",
            "Content-Type": "application/json",
            ]
        
        Alamofire.request(PROJECT_API.POSTLIKEBYUSER, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON
            { response in
                switch response.result {
                case .success(let value):
                   print(value)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
                
        }
    }
    
    func config(){
        self.navigationItem.title = "Detail"
    }
    
    func InitailDetail(){
        lblProductName.text = ProductDetail.title.capitalizingFirstLetter()
        lblProductPrice.text = ProductDetail.cost.toCurrency()
        
        
        if ProductDetail.discount.toDouble() != 0.0
        {
            lblOldPrice.attributedText = ProductDetail.cost.toCurrency().strikeThrough()
            lblProductPrice.text = "\(ProductDetail.cost.toDouble() - ProductDetail.discount.toDouble())".toCurrency()
        }
        else
        {
            lblOldPrice.text = ""
            lblProductPrice.text = ProductDetail.cost.toCurrency()
        }
        
        lblBrand.text = ProductDetail.getBrand
        lblYear.text = ProductDetail.getYear
        lblCondition.text = ProductDetail.condition
        lblColor.text = ProductDetail.color
        lblDescription.text = ProductDetail.description
        lblPrice.text = ProductDetail.cost.toCurrency()
        lblDuration.text = ProductDetail.create_at?.getDuration()
    }
    
    func LoadUserDetail(){
        User.getUserInfo(id: ProductDetail.created_by) { (Profile) in
            self.userdetail = Profile
            self.imgProfilePic.image = Profile.Profile
            self.lblProfileName.text = Profile.Name
            self.lblUserPhoneNumber.text = "Tel: \(Profile.PhoneNumber)"
            self.lblUserEmail.text = "Email: \(Profile.email)"
            self.lblAddress.text = "Address: \(Profile.Address)"
        }
    }
    
    func ImageSlideConfig(){
        CollectView.dataSource = self
        CollectView.delegate = self
        
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    func XibRegister(){
        tblView.register(UINib(nibName: "ProductGridTableViewCell",bundle: nil), forCellReuseIdentifier: "ProductGridCell")
    }
    
    func imageTapped(){
        
    }
    
    @objc func changeImage() {
        if counter < 4 {
            let index = IndexPath.init(item: counter, section: 0)
            self.CollectView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.CollectView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relateArr.count / 2
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "ProductGridCell", for: indexPath) as! ProductGridTableViewCell
        let index = indexPath.row * 2
        cell.data1 = relateArr[index]
        cell.data2 = relateArr[index + 1]
        cell.delegate = self
        cell.reload()
        return cell
        //return UITableViewCell()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? CustomImage {
            performOn(.Main) {
                vc.LoadFromURL(url: self.ProductDetail.arrImage[indexPath.row])
            }
        }
        return cell
    }

}


extension DetailViewController: CellClickProtocol
{
    func cellXibClick(ID: Int) {
        PushToDetailProductViewController(productID: ID)
    }
}

extension CLPlacemark {
    var compactAddrss: String?{
        if let name = name {
            var result = name
            if let street =  thoroughfare{
                result += ", \(street)"
            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
