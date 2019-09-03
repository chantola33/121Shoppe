//
//  ImagePickerUIView.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/15/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import TLPhotoPicker

class ImagePickerUIView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectedAssets = [TLPHAsset]()
    private var DataArr = [imageWithPLAsset]()
    
    var front_image: String?
    var left_image: String?
    var right_image: String?
    var back_image: String?
    var extra_image1: String?
    var extra_image2: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        configXib()
        setUpDataArr()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func setupXib()
    {
        Bundle.main.loadNibNamed("ImagePickerUIView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    private func configXib()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellphoto = UINib(nibName: "PhotoListCollectionViewCell", bundle: nil)
        collectionView.register(cellphoto, forCellWithReuseIdentifier: "photoCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
}

extension ImagePickerUIView
{
    func setUpDataArr()
    {
        self.DataArr.removeAll()
        for _ in 0..<6 {
            self.DataArr.append(imageWithPLAsset(image: UIImage(named: "icons8-plus-math-50 (5)")!, PLAsset: nil, selectedImage: nil))
        }
    }
    
    func refreshSelectAsset()
    {
        for i in 0..<self.selectedAssets.count {
            self.DataArr[i] = imageWithPLAsset(image: UIImage(named: "icons8-plus-math-50 (5)")!, PLAsset: self.selectedAssets[i], selectedImage: nil)
        }
    }
    
    func removeImage(index: Int)
    {
        selectedAssets.remove(at: index)
        setUpDataArr()
        refreshSelectAsset()
        collectionView.reloadData()
    }
    
    func getInstructionMessage(select: Int) -> String
    {
        switch (selectedAssets.count + select) {
            case 0: return "Front Image"
            case 1: return "Left Image"
            case 2: return "Right Image"
            case 3: return "Back Image"
            case 4: return "Extra Image 1"
            case 5: return "Extra Image 2"
            default: return ""
        }
    }
    
    func passingImage(image: UIImage, index: Int)
    {
        switch index
        {
            case 0:
                self.front_image = image.toBase64()
            case 1:
                self.left_image = image.toBase64()
            case 2:
                self.right_image = image.toBase64()
            case 3:
                self.back_image = image.toBase64()
            case 4:
                self.extra_image1 = image.toBase64()
            default:
                self.extra_image2 = image.toBase64()
        }
    }
}

extension ImagePickerUIView: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoListCollectionViewCell
        cell.data = self.DataArr[indexPath.row]
        cell.imageIndex = indexPath.row
        cell.reload { (img) in
            self.passingImage(image: img, index: indexPath.row)
        }
        
        cell.removeImage = { index in
            self.removeImage(index: index)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let TLPhotoPicker = TLPhotosPickerViewController()
        var TLconfig = TLPhotosPickerConfigure()
        
        TLconfig.maxSelectedAssets = 6 - self.selectedAssets.count
        TLconfig.allowedVideo = false
        TLconfig.allowedVideoRecording = false

        
        TLPhotoPicker.delegate = self
        TLPhotoPicker.logDelegate = self
        TLPhotoPicker.configure = TLconfig
        
        let topVC = UIApplication.topViewController()
        topVC?.present(TLPhotoPicker, animated: true, completion: nil)
    }
}

extension ImagePickerUIView: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets += withTLPHAssets
    }
    
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        self.refreshSelectAsset()
        self.collectionView.reloadData()
    }
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        Message.AlertMessage(message: "Image can select only 6.", header: "Warning", View: picker) {
            
        }
    }
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        Message.AlertMessage(message: "Gallery is not avialable.", header: "Warning", View: picker) {
            
        }
    }
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        Message.AlertMessage(message: "Camera is not avialable.", header: "Warning", View: picker) {
            
        }
    }
}

extension ImagePickerUIView: TLPhotosPickerLogDelegate {
    func selectedCameraCell(picker: TLPhotosPickerViewController)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            if let currentView = UIApplication.topViewController()
            {
                currentView.view.makeToast(self.getInstructionMessage(select: picker.selectedAssets.count), duration: 2.0, point: CGPoint(x: currentView.view.frame.width/2, y: 75.0), title: nil, image: nil) { didTap in
                    if didTap {
                        print("completion from tap")
                    } else {
                        print("completion without tap")
                    }
                }
            }
        }
    }
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        
    }
}
