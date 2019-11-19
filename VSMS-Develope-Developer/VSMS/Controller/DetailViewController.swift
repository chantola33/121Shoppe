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
import GooglePlaces
import CoreLocation
import FirebaseDatabase




class DetailViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
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
    
    
    @IBOutlet weak var lblBrand: UILabel!
//    @IBOutlet weak var lblYear: UILabel!
//    @IBOutlet weak var lblColor: UILabel!
    
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var lblUserPhoneNumber: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    
    
    @IBOutlet weak var mapView: GMSMapView!
     lazy var geocoder = CLGeocoder()
     let locationManager = CLLocationManager()
    
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
//        txtinterestRate.text = "1.5"
//        txtTerm.text = "1"
        let create_by = ProductDetail.created_by
        let userid = User.getUserID()
        if create_by == userid {
           self.buttonView.isHidden = true
            self.bottomView.constant = 0
        }
        
//        txtTerm.bordercolor()
//        txtinterestRate.bordercolor()
//        txtdeposit.bordercolor()
//        txtprice.bordercolor()
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.width * 0.5
        // Do any additional setup after loading the view.
        config()
        ImageSlideConfig()
        InitailDetail()
        LoadUserDetail()
        XibRegister()
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
        
//        txtprice.addTarget(self, action: #selector(CalculatorLoan), for: UIControl.Event.editingChanged)
//        txtinterestRate.addTarget(self, action: #selector(CalculatorLoan), for: UIControl.Event.editingChanged)
//        txtTerm.addTarget(self, action: #selector(CalculatorLoan), for: UIControl.Event.editingChanged)
        mapView.delegate = self
        mapView.settings.setAllGesturesEnabled(false)
        
        //self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
//            mapView.settings.setAllGesturesEnabled(false)
//
       }

    }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations Locations: [CLLocation]){
            let Address = ProductDetail.contact_address
            let fullAddress = Address.components(separatedBy: ",")
            let latitude = fullAddress[0].toDouble() //First
            let Longtitude = fullAddress[1].toDouble() //Last
            showSpecificPath(latitude: latitude, Longtitude: Longtitude)

        }
    
        func showSpecificPath(latitude: CLLocationDegrees, Longtitude: CLLocationDegrees){
            let Address = ProductDetail.contact_address
            let fullAddress = Address.components(separatedBy: ",")
            let latitude = fullAddress[0].toDouble() //First
            let Longtitude = fullAddress[1].toDouble() //Last
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: Longtitude, zoom: 16)
            self.mapView?.animate(to: camera)
            self.locationManager.stopUpdatingLocation()
            
            let location = CLLocation(latitude: latitude, longitude: Longtitude)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: Longtitude)
                marker.map = self.mapView
               
            }

        }
    
     private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?){

        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            lblAddress.text = "Unable to Find Address for Location"
        }else{
            if let placemarks = placemarks, let placemark = placemarks.first{
                lblAddress.text = ": \(placemark.compactAddrss ?? "")"
            }else{
                lblAddress.text = "No Maching Address Found"
            }
        }
    
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContectViewController") as! ContectViewController
        vc.UserPostID = ProductDetail.created_by
        vc.userdetail = self.userdetail
        vc.ProductDetail = self.ProductDetail

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //Events Handler
    @IBAction func clickCall(_ sender: Any) {
        print("click call")
//        makeAPhoneCall(phoneNumber: self.ProductDetail.contact_phone)
        let Phone_number = ProductDetail.contact_phone
        let Splitphone = Phone_number.components(separatedBy: ",")
        let phone2 = Splitphone[1]
        let phone3 = Splitphone[2]
        let alert = UIAlertController(title: "Call to the Seller", message: nil, preferredStyle: .actionSheet )
        
        alert.addAction(UIAlertAction(title: Splitphone[0], style: .default, handler: { (_) in
              print(Splitphone[0])
             makeAPhoneCall(phoneNumber: Splitphone[0])
           
        }))
        if phone2 != "" {
        alert.addAction(UIAlertAction(title: Splitphone[1], style: .default, handler: { (_) in
              print(Splitphone[1])
             makeAPhoneCall(phoneNumber: Splitphone[1])

        }))
        }
        if phone3 != ""{
        alert.addAction(UIAlertAction(title: Splitphone[2], style: .default, handler: { (_) in
            print(Splitphone[2])
             makeAPhoneCall(phoneNumber: Splitphone[2])

        }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("Cancel")
        }))
            self.present(alert, animated: true)
    }
    
    @IBAction func clickSms(_ sender: Any) {
        
        if !User.IsUserAuthorized()
        {
            PresentController.LogInandRegister()
            return
        }
        
        let chatdata = MessageViewModel()
        chatdata.username = userdetail?.PhoneNumber
        chatdata.proImage = ProductDetail.front_image_url
        chatdata.proName = ProductDetail.title
        chatdata.proPrice = ProductDetail.cost
        PresentController.PushToMessageViewController(from: self, chatData: chatdata)
    }
    
    @IBAction func clickLike(_ sender: Any) {
        
        if !User.IsUserAuthorized()
        {
            PresentController.LogInandRegister()
            return
        }

        if condtionlike == true {
            let alert = UIAlertController(title: "LIKE", message: "You have like this product already.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let refreshAlert = UIAlertController(title: "LIKE", message: "Like successfully.", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.Btnlikebyuser()
                self.condtionlike = true
                let alert = UIAlertController(title: "LIKE", message: "Like Successfully.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tblView.reloadData()
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
               // self.condtionlike = false
                self.tblView.reloadData()
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }

}
    
    
    @IBAction func clickLoan(_ sender: Any) {
        
        if !User.IsUserAuthorized()
        {
            PresentController.LogInandRegister()
            return
        }
        
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
        let ProductName = ProductDetail.post_sub_title
        let SplitName = ProductName.components(separatedBy: ",")
        if SplitName.count > 1 {
            if UserDefaults.standard.string(forKey: currentLangKey) == "en" {
                lblProductName.text = SplitName[0]
            }else {
                lblProductName.text = SplitName[1]
            }
        }

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
        
        lblBrand.text = ProductDetail.post_code
//        lblYear.text = ProductDetail.getYear
        lblCondition.text = ProductDetail.condition
//        lblColor.text = ProductDetail.post_code
        lblDescription.text = ProductDetail.description
//        lblPrice.text = ProductDetail.cost.toCurrency()

//        lblDuration.text = ProductDetail.create_at?.getDuration()
        RequestHandle.CountView(postID: self.ProductDetail.id) { (count) in
            performOn(.Main, closure: {
                self.lblViews.text = "Views: "+count.toString()
//                let view = "Views: "+count.toString()
//                print(view)
            })
            
            
        }
        
        
        
    }
    
    func LoadUserDetail(){
        User.getUserInfo(id: ProductDetail.created_by) { (Profile) in
            self.userdetail = Profile
            self.imgProfilePic.image = Profile.Profile
            self.lblProfileName.text = Profile.FirstName
            self.lblUserEmail.text = ": \(Profile.email)"
            self.lblAddress.text = ": \(self.ProductDetail.vin_code)"
            
            let Phonenumber = Profile.PhoneNumber
            let SplitNumber = Phonenumber.components(separatedBy: ",")
            if SplitNumber.count > 1 {
            if SplitNumber[1] != "" {
               self.lblUserPhoneNumber.text = ": " + SplitNumber[0] + " / " + SplitNumber[1]
            } else if SplitNumber[2] != "" {
                 self.lblUserPhoneNumber.text = ": " + SplitNumber[0] + " / " + SplitNumber[1]  + " / " + SplitNumber[2]
            }else {
                  self.lblUserPhoneNumber.text = ": " + SplitNumber[0]
                }
            }else { self.lblUserPhoneNumber.text = Profile.PhoneNumber }
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
