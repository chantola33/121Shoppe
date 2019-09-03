//
//  PhotoListCollectionViewCell.swift
//  VSMS
//
//  Created by usah on 3/8/19.
//  Copyright © 2019 121. All rights reserved.
//
import UIKit
import TLPhotoPicker

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView?
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var imageIndex: Int = 0
    var data = imageWithPLAsset(image: UIImage(named: "icons8-plus-math-50 (5)")!, PLAsset: nil, selectedImage: nil)
    var removeImage:((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activity.isHidden = true
    }
    
    func reload(completion: @escaping (UIImage) -> Void){
        
        if data.PLAsset == nil {
            btnRemove.isHidden = true
            postImageView?.image = data.image
            return
        }
        
        self.postImageView?.image = UIImage()
        activity.isHidden = false
        self.progressBar.isHidden = false
        data.PLAsset?.cloudImageDownload(progressBlock: { (data) in
            performOn(.Main, closure: {
                self.activity.startAnimating()
                self.progressBar.progress = Float(data)
            })
        }, completionBlock: { (image) in
            self.progressBar.isHidden = true
            self.progressBar.progress = 0.0
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.postImageView?.image = image
            self.btnRemove.isHidden = false
            completion(image!)
        })
    }
    
    
    @IBAction func btnRemoveClick(_ sender: UIButton) {
        self.removeImage!(imageIndex)
    }
    
}
