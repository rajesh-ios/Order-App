//
//  AvatarView.swift
//  Dodoo
//
//  Created by Banka Rajesh on 11/08/22.
//  Copyright © 2022 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
 

protocol AvatarViewDelegate {
    func didTapAvatarView(_ sender: AvatarView)
}

@IBDesignable
class AvatarView: UIView {
    
    var imageView: UIImageView = UIImageView(image: UIImage(named: "Profile"))
    var containerView: UIView = UIView()
    var editLabel: UILabel = UILabel()
    var button: UIButton = UIButton()
    var delegate: AvatarViewDelegate?
    
    var imageName : String? {
        didSet {
            DispatchQueue.main.async {
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.frame = self.containerView.bounds
            }
            self.imageView.image(url: imageName ?? "", placeholder: UIImage(named: "Profile")!)
        }
    }
    
    var editMode: Bool = false {
        didSet {
            editLabel.isHidden = !editMode
            self.button.isUserInteractionEnabled = editMode
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = containerView.layer.borderColor else {
                return UIColor.white
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                containerView.layer.borderColor = UIColor.white.cgColor
                return
            }
            containerView.layer.borderColor = color.cgColor
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    func sharedInit() {
        // Common logic goes here
        backgroundColor = UIColor.clear

        containerView.backgroundColor = .white
        containerView.layer.borderColor = self.borderColor?.cgColor ?? UIColor.white.cgColor
        containerView.layer.borderWidth = 3
        containerView.clipsToBounds = true
        addSubview(containerView)

        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill

        containerView.addSubview(imageView)

        editLabel.backgroundColor = .white
        editLabel.textColor = .orange
        editLabel.textAlignment = .center
        editLabel.font = UIFont(name: "Montserrat-Bold", size: 11)
        editLabel.text = "Edit"
        containerView.addSubview(editLabel)
        
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        containerView.addSubview(button)

//        user = nil
//        spot = nil
        editMode = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        var w = bounds.size.width
        var h = bounds.size.height
        let s = min(w, h)
        containerView.frame = CGRect(x: CGFloat((w - s) / 2), y: CGFloat((h - s) / 2), width: CGFloat(s), height: CGFloat(s))
        containerView.layer.cornerRadius = CGFloat(s / 2)
        
        button.frame = containerView.bounds

        w = CGFloat(containerView.bounds.size.width)
        h = CGFloat(containerView.bounds.size.height)
        editLabel.frame = CGRect(x: 0, y: CGFloat(h * 0.75), width: CGFloat(s), height: CGFloat(h * 0.25))

//        if user != nil || spot != nil {
//            imageView.frame = containerView.bounds
//        } else {
//            imageView.frame = CGRect(x: CGFloat(w * 0.20), y: CGFloat(h * 0.20), width: CGFloat(w * 0.6), height: CGFloat(h * 0.6))
//        }
    }

    @IBAction func onButtonTap(sender: UIButton!) {
        guard let delegate = self.delegate else {
            return
        }
        if editMode {
            delegate.didTapAvatarView(self)
        }
    }
}
