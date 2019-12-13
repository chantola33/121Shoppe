//
//  SearchFilterController.swift
//  VSMS
//
//  Created by usah on 12/9/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit
class SearchFilterController:  UIViewController {
    
   
    @IBOutlet weak var Searchbar: UISearchBar!
    @IBOutlet weak var lblSlideValue: UILabel!
    
    @IBOutlet weak var vType: UIView!
    @IBOutlet weak var lblType: UILabel!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
     
       vType.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickType))
        vType.addGestureRecognizer(tapGesture)
    }
    
    @objc func onClickType() {
        print("thleak")
        selectedButton = vType
        addTransparentView(frames: vType.frame)
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = 0.5
              self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 200)
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = 0
              self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
    @IBAction func onSubmitFilter(_ sender: Any) {
       let tt = Searchbar.text
        print(tt)
        let termof: SearchTesting =
            self.storyboard?.instantiateViewController(withIdentifier: "SearchTesting") as!
        SearchTesting
        self.navigationController?.pushViewController(termof, animated: true)
    }
    
    @IBAction func onScrollSlider(_ sender: UISlider) {
        lblSlideValue.text = String(sender.value)
    }
    
    
}


