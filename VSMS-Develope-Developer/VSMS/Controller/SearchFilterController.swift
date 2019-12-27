//
//  SearchFilterController.swift
//  VSMS
//
//  Created by usah on 12/9/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit

class SearchFilterController:  UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate {

    @IBOutlet weak var Searchbar: UISearchBar!
    @IBOutlet weak var lblSlideValue: UILabel!
    
    @IBOutlet weak var vType: UIView!
//    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var txCategory: UITextField!
    
    @IBOutlet weak var txType: UITextField!
    
    @IBOutlet weak var txBrand: UITextField!
    @IBOutlet weak var txyear: UITextField!
    var post_arr = [DropDownTemplate]()
    var category_arr = [DropDownTemplate]()
    var brand_arr = [DropDownTemplate]()
    var year_arr = [DropDownTemplate]()

    var myPickerView: UIPickerView!
    var pickerData = [DropDownTemplate]()
    var s = 0
    var search_title = ""
    var post_type = ""
    var category = ""
    var brand  = ""
    var year = ""
    override func viewDidLoad(){
        super.viewDidLoad()
      
        
        
        textFieldImagesetup(txField: txType)
         textFieldImagesetup(txField: txCategory)
         textFieldImagesetup(txField: txBrand)
         textFieldImagesetup(txField: txyear)
        
        self.post_arr = GenerateList.getPostType()
        GenerateList.getCategory { (val) in
            self.category_arr = val
          
        }
        GenerateList.getBrand { (val) in
            self.brand_arr = val
           
        }
        GenerateList.getYear { (val) in
            self.year_arr = val
        }
        
      txType.addTarget(self, action: #selector(SearchFilterController.textFieldDidChange(_:)), for: UIControl.Event.allTouchEvents)
        
      txCategory.addTarget(self, action: #selector(SearchFilterController.textFieldDidChange(_:)), for: UIControl.Event.allTouchEvents)
      
      txBrand.addTarget(self, action: #selector(SearchFilterController.textFieldDidChange(_:)), for: UIControl.Event.allTouchEvents)
      txyear.addTarget(self, action: #selector(SearchFilterController.textFieldDidChange(_:)), for: UIControl.Event.allTouchEvents)
//        vType.layer.cornerRadius = 5
//        vType.layer.borderWidth = 0.5
//        vType.layer.borderColor = UIColor.lightGray.cgColor
//
//        let cn: String = Shared.shared.companyName ?? "Select Category"
//        lblType.text = cn
//       vType.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickType))
//        vType.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case txType:
            s = 1
            pickerData = selection(s: 1)
            self.pickUp(txType)
        case txCategory:
            s = 2
            pickerData = selection(s: 2)
            self.pickUp(txCategory)
        case txBrand:
            s = 3
            pickerData = selection(s: 3)
            self.pickUp(txBrand)
        case txyear:
            s = 4
            pickerData = selection(s: 4)
            self.pickUp(txyear)
        default:
            break
        }
    }
//    @objc func onClickType() {
//        print("thleak")
////        let story: UIStoryboard = UIStoryboard(name: "Alert", bundle: nil)
////        let vc: AlertDialog = story.instantiateViewController(withIdentifier: "AlertDialog") as! AlertDialog
////        self.present(vc, animated: true, completion: nil)
//    }
  
    func textFieldImagesetup(txField: UITextField){
        txField.rightViewMode = .always
      
        let imageView = UIImageView()
        let image = UIImage(named: "dropdown")
        imageView.image = image
        imageView.frame = CGRect(x: 2, y: 0, width: txField.frame.height, height: txField.frame.height)
        txField.rightView = imageView
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Searchbar.resignFirstResponder()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func pickUp(_ textField: UITextField) {
        self.myPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SearchFilterController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SearchFilterController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
   
    @objc func doneClick() {
        switch (s) {
        case 1: txType.resignFirstResponder()
        case 2: txCategory.resignFirstResponder()
        case 3: txBrand.resignFirstResponder()
        case 4: txyear.resignFirstResponder()
        default: break
        }
        
    }
    @objc func cancelClick() {
        switch (s) {
        case 1: txType.resignFirstResponder()
        case 2: txCategory.resignFirstResponder()
        case 3: txBrand.resignFirstResponder()
        case 4: txyear.resignFirstResponder()
        default: break
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return pickerData[row].Text
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        switch(s){
            case 1:   self.txType.text = post_arr[row].Text
                      post_type = post_arr[row].Text ?? ""
            case 2:   self.txCategory.text = category_arr[row].Text
                      category = category_arr[row].ID ?? ""
            case 3:   self.txBrand.text = brand_arr[row].Text
                      brand = brand_arr[row].ID ?? ""
            case 4:   self.txyear.text = year_arr[row].Text
                      year = year_arr[row].ID ?? ""
            default: print("error something")
        }
    }
    
    
    func selection(s: Int) ->[DropDownTemplate]{
         var data = [DropDownTemplate]()
        switch (s)
        {
        case 1:
            data = self.post_arr
            break
        case 2:
            data = self.category_arr
            break
        case 3:
            data = self.brand_arr
            break
        case 4:
            data = self.year_arr
            break
        default: break
            
        }
        return data
    }

    ///// button submit
    @IBAction func onSubmitFilter(_ sender: Any) {
       let tt = Searchbar.text
        print(tt ?? "")
        let termof: SearchResult =
            self.storyboard?.instantiateViewController(withIdentifier: "SearchResult") as!
        SearchResult
        termof.search_title = search_title
        termof.post_type = post_type
        termof.category = category
        termof.year = year
        self.navigationController?.pushViewController(termof, animated: true)
    }
    
    @IBAction func onScrollSlider(_ sender: UISlider) {
        lblSlideValue.text = String(sender.value)
    }
    
    
}


