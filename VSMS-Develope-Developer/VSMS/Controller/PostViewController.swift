//
//  PostViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/14/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import RSSelectionMenu
import GoogleMaps
import GooglePlaces
import MapKit
import TLPhotoPicker


class PostViewController: UITableViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    ///Image Picker
    @IBOutlet weak var imagePicker: ImagePickerUIView!
    
    ///Detail
    @IBOutlet weak var postType: CusDropDownUIView!
    @IBOutlet weak var cboCategory: CusDropDownUIView!
    @IBOutlet weak var cboType: CusDropDownUIView!
    @IBOutlet weak var cboBrand: CusDropDownUIView!
    @IBOutlet weak var cboModel: CusDropDownUIView!
    @IBOutlet weak var cboYear: CusDropDownUIView!
    @IBOutlet weak var cboCondition: CusDropDownUIView!
    @IBOutlet weak var cboColor: CusDropDownUIView!
    @IBOutlet weak var txtDescription: CusTextAreaInput!
    @IBOutlet weak var txtPrice: CusInputUIView!
    // machine section
    @IBOutlet weak var txtWholeink: CusInputUIView!
    @IBOutlet weak var txtFrontWheelset: CusInputUIView!
    @IBOutlet weak var txtWholeScrew: CusInputUIView!
    @IBOutlet weak var txtFrontrearpump: CusInputUIView!
    
    @IBOutlet weak var txtLeftRightengine: CusInputUIView!
    @IBOutlet weak var txtEnginehead: CusInputUIView!
    @IBOutlet weak var txtMachineassembly: CusInputUIView!
    @IBOutlet weak var txtConsole: CusInputUIView!
    @IBOutlet weak var txtAccessories: CusInputUIView!
    //Discount
    @IBOutlet weak var cboDiscountType: CusDropDownUIView!
    @IBOutlet weak var txtDiscountAmount: CusInputUIView!
    //Contact
    @IBOutlet weak var txtName: CusInputUIView!
    @IBOutlet weak var txtPhoneNumber: CusInputUIView!
    @IBOutlet weak var txtEmail: CusInputUIView!
    //submit
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtaddress: UITextField!
    //map
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    /////
    var post_arr = [DropDownTemplate]()
    var category_arr = [DropDownTemplate]()
    var type_arr = [DropDownTemplate]()
    var brand_arr = [DropDownTemplate]()
    var model_arr = [DropDownTemplate]()
    var year_arr = [DropDownTemplate]()
    var condition_arr = [DropDownTemplate]()
    var color_arr = [DropDownTemplate]()
    var discount_type_arr = [DropDownTemplate]()
 
    /////selected arr
    var post_selected = [DropDownTemplate]()
    var category_selected = [DropDownTemplate]()
    var type_selected = [DropDownTemplate]()
    var brand_selected = [DropDownTemplate]()
    var model_selected = [DropDownTemplate]()
    var year_selected = [DropDownTemplate]()
    var condition_selected = [DropDownTemplate]()
    var color_selected = [DropDownTemplate]()
    var discount_type_selected = [DropDownTemplate]()
    var random = Int.random(in: 0...1000000000)
    var post_code: String = ""
    //Internal Properties
    var post_obj = PostAdViewModel()
    var dispatch = DispatchGroup()
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
    
    var is_edit = false
    var post_id: Int?
    var sub_title: [String] = ["","","",""]
    var sub_title_kh: [String] = ["","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Post Ad"
        
        ShowDefaultNavigation()
        Prepare()
        PrepareToEdit()
        
        mapView.delegate = self
        isAuthorizedtoGetUserLocation()
        self.mapView?.isMyLocationEnabled = true
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
        
        if IsNilorEmpty(value: post_obj.contact_address)
        {
            let userLocation:CLLocation = locations[0] as CLLocation
            self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        }
        else{
            let fullAddress = post_obj.contact_address.components(separatedBy: ",")
            let latitude = fullAddress[0].toDouble() //First
            let Longtitude = fullAddress[1].toDouble() //Last
            self.currentLocation = CLLocationCoordinate2D(latitude: latitude,longitude: Longtitude)
        }
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 16)
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
    
    // MARK: - Table view data source
    
    @IBAction func SubmitHandler(_ sender: UIButton) {
      
        let alertMessage = UIAlertController(title: nil, message: "Uploading Product", preferredStyle: .alert)
        alertMessage.addActivityIndicator()
        self.present(alertMessage, animated: true, completion: nil)
        
        post_obj.post_sub_title = sub_title[0] + " " + sub_title[1] + " " + sub_title[2] + " " + sub_title[3] + "," + sub_title_kh[0] + " " + sub_title_kh[1] + " " + sub_title_kh[2] + " " + sub_title_kh[3]
        post_obj.cost = txtPrice.Value
        post_obj.description = txtDescription.Value
        post_obj.discount = txtDiscountAmount.Value == "" ? "0": txtDiscountAmount.Value
        post_obj.name = txtName.Value
        post_obj.contact_phone = txtPhoneNumber.Value
        post_obj.contact_email = txtEmail.Value
        post_obj.vin_code = txtaddress.text!
        post_obj.contact_address = latlog        
        post_obj.machine_code = txtName.Value
     
        //machine section by samangy 24/10/19
        post_obj.used_eta1 = txtWholeink.Value == "" ? "0": txtWholeink.Value
        post_obj.used_eta2 = txtFrontWheelset.Value == "" ? "0": txtFrontWheelset.Value
        post_obj.used_eta3 = txtWholeScrew.Value == "" ? "0": txtWholeScrew.Value
        post_obj.used_eta4 = txtFrontrearpump.Value == "" ? "0": txtFrontrearpump.Value
        post_obj.used_machine1 = txtLeftRightengine.Value == "" ? "0": txtLeftRightengine.Value
        post_obj.used_machine2 = txtEnginehead.Value == "" ? "0": txtEnginehead.Value
        post_obj.used_machine3 = txtMachineassembly.Value == "" ? "0": txtMachineassembly.Value
        post_obj.used_machine4 = txtConsole.Value == "" ? "0": txtConsole.Value
        post_obj.used_other1 = txtAccessories.Value == "" ? "0": txtAccessories.Value
        
        post_obj.front_image_path = imagePicker.front_image
        post_obj.left_image_path = imagePicker.left_image
        post_obj.right_image_path = imagePicker.right_image
        post_obj.back_image_path = imagePicker.back_image
        post_obj.extra_image1 = imagePicker.extra_image1
        post_obj.extra_image2 = imagePicker.extra_image2
        
        if is_edit
        {
            post_obj.Update { (result) in
                alertMessage.dismissActivityIndicator()
                if result{
                    Message.SuccessMessage(message: "Product updated successfully.", View: self, callback: {
                       PresentController.ProfileController()
                    })
                }

            }
        }
        else{
            post_obj.post_code = random.toString()
            post_obj.Save { (result) in
                    alertMessage.dismissActivityIndicator()
                    if result{
                        Message.SuccessMessage(message: "Product uploaded successfully.", View: self, callback: {
                            PresentController.ProfileController()
                        })
                    }
                    
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if is_edit
        {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            PresentController.ProfileController()
        }
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 && isMotorBike_Used()
        {
            return UIView()
        }
        if section == 3 && isBuy()
        {
            return UIView()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return CGFloat.leastNonzeroMagnitude
        }
        
        if section == 2 && isMotorBike_Used()
        {
            return CGFloat.leastNonzeroMagnitude
        }
        
        if section == 3 && isBuy()
        {
            return CGFloat.leastNonzeroMagnitude
        }
        
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightbyIndexPath(indexpath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return 1
        case 1:
            return 10
        case 2:
            if isMotorBike_Used() {
                return 0
            }
            return 11
        case 3:
            if isBuy() {
                return 0
            }
            return 2
        case 4:
            return 4
        case 5:
            return 1
      
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1
        {
            switch indexPath.row
            {
            case 0:
                guard !is_edit else{
                    tableView.deselectRow(at: indexPath, animated: false)
                    return
                }
                self.ShowPostTypeOption(style: .push)
            case 2:
                self.ShowCategoryOption(style: .push)
            case 3:
                self.ShowTypeOption(style: .push)
            case 4:
                self.ShowBrandOption(style: .push)
            case 5:
                self.ShowModelOption(style: .push)
            case 6:
                self.ShowYearOption(style: .push)
            case 7:
                self.ShowConditionOption(style: .push)
            case 8:
                self.ShowColorOption(style: .push)
            default:
                break
            }
        }
        if indexPath.section == 3 && indexPath.row == 0
        {
            self.ShowDiscountTypeOption(style: .push)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension PostViewController {
    func Prepare()
    {
        self.txtName.Value = post_obj.name
        self.txtPhoneNumber.Value = post_obj.contact_phone
        self.post_arr = GenerateList.getPostType()
        self.color_arr = GenerateList.getColor()
        self.discount_type_arr = GenerateList.getDiscountType()
        self.condition_arr = GenerateList.getCondition()
        
        dispatch.enter()
        GenerateList.getCategory { (val) in
            self.category_arr = val
            self.dispatch.leave()
        }
        dispatch.enter()
        GenerateList.getType { (val) in
            self.type_arr = val
            self.dispatch.leave()
        }
        dispatch.enter()
        GenerateList.getBrand { (val) in
            self.brand_arr = val
            self.dispatch.leave()
        }
        dispatch.enter()
        GenerateList.getModel { (val) in
            self.model_arr = val
            self.dispatch.leave()
        }
        dispatch.enter()
        GenerateList.getYear { (val) in
            self.year_arr = val
            self.dispatch.leave()
        }
        
    }
    
    func PrepareToEdit()
    {
        guard let ProductID = self.post_id else {
            return
        }
        
        is_edit = true
        btnSubmit.setTitle("Update", for: .normal)
        isAuthorizedtoGetUserLocation()
        dispatch.notify(queue: .main) {
            self.post_obj.Load(PostID: ProductID) { (data) in
                self.post_obj = data
                
                self.postType.Value = data.post_type.capitalizingFirstLetter()
            
                self.cboCategory.Value = self.category_arr.first(where: {$0.ID == data.category.toString()})!.Text!
                self.cboType.Value = self.type_arr.first(where: {$0.ID == data.type.toString()})!.Text!
                
                let Brand = self.model_arr.first(where: {$0.ID == data.modeling.toString()})!
                self.cboBrand.Value = self.brand_arr.first(where: {$0.ID == Brand.Fkey})!.Text!
                //set value post sub title
                self.sub_title.insert(self.brand_arr.first(where: {$0.ID == Brand.Fkey})!.Text!, at: 0)
                self.sub_title_kh.insert(self.brand_arr.first(where: {$0.ID == Brand.Fkey})!.Text_kh!, at: 0)
                
                self.post_obj.brand = (self.brand_arr.first(where: {$0.ID == Brand.Fkey})?.ID?.toInt())!
                
                self.cboModel.Value = self.model_arr.first(where: {$0.ID == data.modeling.toString()})!.Text!
                //set value post sub title
                self.sub_title.insert(self.model_arr.first(where: {$0.ID == data.modeling.toString()})!.Text!, at: 1)
                self.sub_title_kh.insert(self.model_arr.first(where: {$0.ID == data.modeling.toString()})!.Text_kh!, at: 1)
                
                self.cboYear.Value = self.year_arr.first(where: {$0.ID == data.year.toString()})!.Text!
                //set value post sub title
                self.sub_title.insert(self.year_arr.first(where: {$0.ID == data.year.toString()})!.Text!, at: 2)
                self.sub_title_kh.insert(self.year_arr.first(where: {$0.ID == data.year.toString()})!.Text_kh!, at: 2)
                
                self.cboCondition.Value = self.condition_arr.first(where: {$0.ID == data.condition})!.Text!
                self.cboColor.Value = self.color_arr.first(where: {$0.ID == data.color})!.Text!
                //set value post sub title
                self.sub_title.insert(self.color_arr.first(where: {$0.ID == data.color})!.Text!, at: 3)
                self.sub_title_kh.insert(self.color_arr.first(where: {$0.ID == data.color})!.Text_kh!, at: 3)
                
                self.txtDescription.Value = data.description
                self.txtPrice.Value = data.cost
                
                self.cboDiscountType.Value = self.discount_type_arr.first(where: {$0.ID == data.discount_type})!.Text!
                self.txtDiscountAmount.Value = data.discount
                
                self.txtName.Value = data.machine_code
                self.txtPhoneNumber.Value = data.contact_phone
                self.txtEmail.Value = data.contact_email
              // section machine by samang 28/10/19
                self.txtWholeink.Value = data.used_eta1
                self.txtFrontWheelset.Value = data.used_eta2
                self.txtWholeScrew.Value = data.used_eta3
                self.txtFrontrearpump.Value = data.used_eta4
                self.txtLeftRightengine.Value = data.used_machine1
                self.txtEnginehead.Value = data.used_machine2
                self.txtMachineassembly.Value = data.used_machine3
                self.txtConsole.Value = data.used_machine4
                self.txtAccessories.Value = data.used_other1
               
                self.imagePicker.back_image = data.back_image_path
                self.imagePicker.front_image = data.front_image_path
                self.imagePicker.left_image = data.left_image_path
                self.imagePicker.right_image = data.right_image_path
                self.tableView.reloadData()
               
              
            }
        }
    }
    
    func ShowPostTypeOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: post_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: post_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.post_selected = selectedItems
            self?.postType.Value = text!.Text!
            self?.post_obj.post_type = (text?.ID)!
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Post Type"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowCategoryOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: category_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: category_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.category_selected = selectedItems
            self?.cboCategory.Value = text!.Text!
            self?.post_obj.category = (text?.ID?.toInt())!
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Category"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowTypeOption(style: PresentationStyle)
    {
        
        let selectionMenu = RSSelectionMenu(dataSource: type_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: type_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.type_selected = selectedItems
            self?.cboType.Value = text!.Text!
            self?.post_obj.type = (text?.ID?.toInt())!
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Type"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowBrandOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: brand_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: brand_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.brand_selected = selectedItems
            self?.cboBrand.Value = text!.Text!
            self?.post_obj.brand = (text?.ID?.toInt())!
            self?.sub_title.insert(text!.Text!, at: 0)
            self?.sub_title_kh.insert(text!.Text_kh!, at: 0)
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Brand"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowModelOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: model_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: model_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.model_selected = selectedItems
            self?.cboModel.Value = text!.Text!
            self?.post_obj.modeling = (text?.ID?.toInt())!
            self?.sub_title.insert(text!.Text!, at: 1)
            self?.sub_title_kh.insert(text!.Text_kh!, at: 1)
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Model"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowYearOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: year_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: year_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.year_selected = selectedItems
            self?.cboYear.Value = text!.Text!
            self?.post_obj.year = (text?.ID?.toInt())!
            self?.sub_title.insert(text!.Text!, at: 2)
            self?.sub_title_kh.insert(text!.Text!, at: 2)
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Year"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowConditionOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: condition_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: condition_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.condition_selected = selectedItems
            self?.cboCondition.Value = text!.Text!
            self?.post_obj.condition = (text?.ID)!
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Condition"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowColorOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: color_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: color_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.color_selected = selectedItems
            self?.cboColor.Value = text!.Text!
            self?.post_obj.color = (text?.ID)!
            self?.sub_title.insert(text!.Text!, at: 3)
            self?.sub_title_kh.insert(text!.Text_kh!, at: 3)
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Color"
        selectionMenu.show(style: style, from: self)
    }
    
    func ShowDiscountTypeOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: discount_type_arr)
        { (cell, item, indexPath) in
            cell.textLabel?.text = item.Text
        }
        
        selectionMenu.setSelectedItems(items: discount_type_selected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self?.discount_type_selected = selectedItems
            self?.cboDiscountType.Value = text!.Text!
            self?.post_obj.discount_type = (text?.ID)!
            self?.tableView.reloadData()
        }
        selectionMenu.navigationItem.title = "Discount Type"
        selectionMenu.show(style: style, from: self)
    }
    
    ///////// Check Functions
    func isBuy() -> Bool
    {
        if self.post_obj.post_type == "buy"
        {
            return true
        }
        return false
    }
    func isMotorBike_Used() -> Bool
    {
        if self.post_obj.category == 2 && self.post_obj.condition == "used"
        {
            return false
        }
        return true
    }
    func isMotorBike() -> Bool
    {
        if self.post_obj.category == 2
        {
            return true
        }
        return false
    }
    
    
    //////// Table
    func getHeightbyIndexPath(indexpath: IndexPath) -> CGFloat
    {
        if indexpath.section == 0 && indexpath.row == 0
        {
            return 130
        }
        if indexpath.section == 1 && indexpath.row == 9
        {
            return 90
        }
        if indexpath.section == 1 && indexpath.row == 3 && isMotorBike()
        {
            return CGFloat.leastNonzeroMagnitude
        }
        
        if indexpath.section == 3 && indexpath.row == 3
        {
            return 260
        }
        if indexpath.section == 4 && indexpath.row == 3
        {
            return 280
        }
        return 50
    }
}

