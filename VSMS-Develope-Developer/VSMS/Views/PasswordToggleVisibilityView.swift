//
//  PasswordToggleVisibilityView.swift
//  VSMS
//
//  Created by Rathana on 8/16/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit

protocol PasswordToggleVisibilityDelegate: class {
    func viewWasToggled(_ passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool)
}

class PasswordToggleVisibilityView: UIView {
    fileprivate let eyeopen: UIImage
    fileprivate let eyeclose: UIImage
    fileprivate let checkmark: UIImage
    fileprivate let eyeButton: UIButton
    fileprivate let checkmarkImageView: UIImageView
    weak var delegate: PasswordToggleVisibilityDelegate?
    
    enum EyeState {
        case open
        case closed
    }
    
    var eyeState: EyeState {
        set {
            eyeButton.isSelected = newValue == .open
        }
        get {
            return eyeButton.isSelected ? .open : .closed
        }
    }
    
    var checkmarkVisible: Bool {
        set {
            let isHidden = !newValue
            guard checkmarkImageView.isHidden != isHidden else {
                return
            }
            checkmarkImageView.isHidden = isHidden
        }
        get {
            return !checkmarkImageView.isHidden
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            eyeButton.tintColor = UIColor.darkGray
            checkmarkImageView.tintColor = UIColor.darkGray
        }
    }
    
    override init(frame: CGRect) {
        self.eyeopen = UIImage(named: "eyeopen", in: Bundle(for: PasswordToggleVisibilityView.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        self.eyeclose = UIImage(named: "eyeclose", in: Bundle(for: PasswordToggleVisibilityView.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        self.checkmark = UIImage(named: "checkmark", in: Bundle(for: PasswordToggleVisibilityView.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        self.eyeButton = UIButton(type: .custom)
        self.checkmarkImageView = UIImageView(image: self.checkmark)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use init with coder.")
    }
    
    fileprivate func setupViews() {
        let padding: CGFloat = 10
        let buttonWidth = (frame.width / 2) - padding
        let buttonFrame = CGRect(x: buttonWidth + padding, y: 0, width: buttonWidth, height: frame.height)
        eyeButton.frame = buttonFrame
        eyeButton.backgroundColor = UIColor.clear
        eyeButton.adjustsImageWhenHighlighted = false
        eyeButton.setImage(self.eyeclose, for: UIControl.State())
        eyeButton.setImage(self.eyeopen.withRenderingMode(.alwaysTemplate), for: .selected)
        eyeButton.addTarget(self, action: #selector(PasswordToggleVisibilityView.eyeButtonPressed(_:)), for: .touchUpInside)
        eyeButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eyeButton.tintColor = UIColor.lightGray
        self.addSubview(eyeButton)
        
        let checkmarkImageWidth = (frame.width / 2) - padding
        let checkmarkFrame = CGRect(x: padding, y: 0, width: checkmarkImageWidth, height: frame.height)
        checkmarkImageView.frame = checkmarkFrame
        checkmarkImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        checkmarkImageView.contentMode = .center
        checkmarkImageView.backgroundColor = UIColor.clear
        checkmarkImageView.tintColor = UIColor.lightGray
        self.addSubview(checkmarkImageView)
        
        self.checkmarkImageView.isHidden = false
    }
    
    
    @objc func eyeButtonPressed(_ sender: AnyObject) {
        eyeButton.isSelected = !eyeButton.isSelected
        delegate?.viewWasToggled(self, isSelected: eyeButton.isSelected)
    }
}
