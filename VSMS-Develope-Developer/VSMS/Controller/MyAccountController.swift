//
//  MyAccountController.swift
//  VSMS
//
//  Created by usah on 3/20/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import RSSelectionMenu
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import CoreLocation
import MapKit

class MyAccountController: UITableViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    
    //Storyboard Properties
    @IBOutlet weak var lblUserGroup: UILabel!
    @IBOutlet weak var txtUsername: UITextField!

    
    @IBOutlet weak var txtaddress: UITextField!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var lblPOB: UILabel!
    @IBOutlet weak var lblMarritalStatus: UILabel!
    @IBOutlet weak var txtWingName: UITextField!
    @IBOutlet weak var txtWingNumber: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnPin: UIButton!
    //    lazy var geocoder = CLGeocoder()
    //   let locationManager = CLLocationManager()
    var latlog: String = ""
   
    var currentLocation:CLLocationCoordinate2D!
    var finalPositionAfterDragging:CLLocationCoordinate2D?
    var locationMarker:GMSMarker!
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    //Internal Properties
    var UserAccount = AccountViewModel()
    let datePicker = UIDatePicker()
    
    //Dropdown Array
    let genderArr = ["Male", "Female"]
    var gender = [String]()
    
    var provinceArr: [DropDownTemplate] = []
    var provinceSelected = [DropDownTemplate]()
    var locationSelected = [DropDownTemplate]()
    
    var maritalStatusArr: [DropDownTemplate] = []
    var maritalStatusSelected = [DropDownTemplate]()
    

    //selected Data
    
    

    let simpleDataArray = ["Sachin", "Rahul", "Saurav", "Virat", "Suresh", "Ravindra", "Chris"]
    var simpleSelectedArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //configuration
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.title = "My Account"
        
        PrepareForDropDown()
        
        self.view.makeToastActivity(.center)
        UserAccount.LoadUserAccount {
            self.view.hideToastActivity()
            self.setUpAccountData()
            self.isAuthorizedtoGetUserLocation()
        }

        ///Add done keyboard
        txtUsername.addDoneButtonOnKeyboard()
        txtPhoneNumber.addDoneButtonOnKeyboard()
        txtWingName.addDoneButtonOnKeyboard()
        txtWingNumber.addDoneButtonOnKeyboard()
        
        ///Currentlocationuser and search
        mapView.delegate = self
       // lblAddress.layer.zPosition  = 1
        self.mapView?.isMyLocationEnabled = true
        
        ////configfunction
        configDateOfBirthOption()

    }
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition){
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    
    
    func wrapperFunctionToShowPosition(mapView:GMSMapView){
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)

        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                self.txtaddress.text = address
                
                let lat = latitute
                let long = longitude
                self.latlog = ("\(lat),\(long)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if IsNilorEmpty(value: UserAccount.ProfileData.address)
        {
            let userLocation:CLLocation = locations[0] as CLLocation
            self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        }
        else{
            let fullAddress = UserAccount.ProfileData.address.components(separatedBy: ",")
            let latitude = fullAddress[0].toDouble() //First
            let Longtitude = fullAddress[1].toDouble() //Last
            self.currentLocation = CLLocationCoordinate2D(latitude: latitude,longitude: Longtitude)
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 14)
        let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
        self.setupLocationMarker(coordinate: position)
        self.mapView.camera = camera
        self.mapView?.animate(to: camera)
        manager.stopUpdatingLocation()
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
    
        print("setup location")
    if locationMarker != nil {
            locationMarker.map = nil
        }

    }
    
    func setUpAccountData()
    {
        let group = UserAccount.ProfileData.group
        
        lblUserGroup.getUserGroupFromAPI(userGroupID: UserAccount.ProfileData.group ?? 0)
        txtUsername.text = UserAccount.firstname == "" ? UserAccount.username : UserAccount.firstname
        lblGender.text = UserAccount.ProfileData.gender.capitalizingFirstLetter()
        txtDob.text = UserAccount.ProfileData.date_of_birth.DateFormat()
        lblPOB.getProvinceFromAPI(ProvinceID: UserAccount.ProfileData.place_of_birth ?? 0)
        lblMarritalStatus.text = UserAccount.ProfileData.marital_status.capitalizingFirstLetter()
        lblLocation.getProvinceFromAPI(ProvinceID: UserAccount.ProfileData.province ?? 0)
        txtPhoneNumber.text = UserAccount.ProfileData.telephone
        txtWingName.text = UserAccount.ProfileData.wing_account_name
        txtWingNumber.text = UserAccount.ProfileData.wing_account_number
        txtaddress.text = UserAccount.ProfileData.responsible_officer
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row
        {
        case 1:
            self.ShowGenderOption(style: .push)
        case 3:
            self.ShowProvinceOption(style: .push)
        case 4:
            self.ShowMarritalStatusOption(style: .push)
        case 5:
            self.ShowLocationOption(style: .push)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //////////////
    ////DateTimePicker
    func configDateOfBirthOption()
    {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDob.inputAccessoryView = toolbar
        txtDob.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDob.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func btnSubmitHandle(_ sender: UIButton)
    {
        
        if txtUsername.text == ""
        {
            return
        }
        
        let alertMessage = UIAlertController(title: nil, message: "Updating Profile", preferredStyle: .alert)
        alertMessage.addActivityIndicator()
        self.present(alertMessage, animated: true, completion: nil)
        
        UserAccount.firstname = txtUsername.text!
        UserAccount.ProfileData.date_of_birth = txtDob.text!.toISODate()
        UserAccount.ProfileData.telephone = txtPhoneNumber.text!
        UserAccount.ProfileData.wing_account_name = txtWingName.text!
        UserAccount.ProfileData.wing_account_number = txtWingNumber.text!
        UserAccount.ProfileData.address = latlog
        UserAccount.ProfileData.responsible_officer = txtaddress.text!
        UserAccount.UpdateUserAccount {
            alertMessage.dismissActivityIndicator()
            
        }
    }
    
}



extension MyAccountController {
    
    func ShowMarritalStatusOption(style: PresentationStyle)
    {
        
        let selectionMenu = RSSelectionMenu(dataSource: maritalStatusArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: maritalStatusSelected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.lblMarritalStatus.text = text?.Text
            self?.maritalStatusSelected = selectedItems
            self?.UserAccount.ProfileData.marital_status = (text?.ID)!
            self?.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowGenderOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: genderArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items: gender) { [weak self] (text, index, isSelected, selectedItems) in
            self?.gender = selectedItems
            self?.lblGender.text = text
            self?.UserAccount.ProfileData.gender = (text?.lowercased())!
            self?.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowProvinceOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: provinceArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: provinceSelected) { [weak self] (text, index, isSelected, selectedItems) in
            self?.provinceSelected = selectedItems
            self?.lblPOB.text = text?.Text
            self?.UserAccount.ProfileData.place_of_birth = text?.ID?.toInt()
            self?.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowLocationOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: provinceArr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: locationSelected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.locationSelected = selectedItems
            self?.lblLocation.text = text?.Text
            self?.UserAccount.ProfileData.province = text?.ID?.toInt()
            self?.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func PrepareForDropDown()
    {
        performOn(.Main) {
            Functions.getProvinceList(ProvinceURL: PROJECT_API.PROVINCES, completion: { (val) in
                self.provinceArr = val
            })
            
            self.maritalStatusArr = Functions.getMaritalStautsList()
        }
    }
}


extension UILabel {
    
    func getProvinceFromAPI(ProvinceID: Int)
    {
        Alamofire.request("\(PROJECT_API.PROVINCES)\(ProvinceID)/",
                            method: .get,
                            encoding: JSONEncoding.default
            ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                let provinceName = json["province"].stringValue

                performOn(.Main, closure: {
                    self.text = provinceName
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserGroupFromAPI(userGroupID: Int)
    {
        Alamofire.request("\(PROJECT_API.GROUPS)\(userGroupID)/",
            method: .get,
            encoding: JSONEncoding.default
            ).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
//                    let groups = JSON(json["results"].arrayValue.first(where: { $0["id"].stringValue == userGroupID.toString() })!)
                    
//                    performOn(.Main, closure: {
//                        self.text = groups["name"].stringValue
//                    })
                    let group = json["name"].stringValue
                    performOn(.Main,closure: {
                        self.text = group
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}



