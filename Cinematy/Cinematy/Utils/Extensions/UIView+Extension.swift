//
//  UIView.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit

extension UIView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var dropShadow: Bool {
        get{
            return false
        }
        set {
            self.dropShadow(apply: newValue)
            
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    func startRotating() {
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations:
                        { () -> Void in
            self.transform = self.transform.rotated(by: CGFloat(Double.pi/2))
        }) { (finished) -> Void in
            if self.tag == 10{
                self.startRotating()
            }else{
                self.isHidden = true
            }
        }
        tag = 10
    }
    
    
    
    func stopRotating() {
        
        tag = 0
        
    }
    
    func dropShadow(apply : Bool) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = apply ? UIColor.black.cgColor : UIColor.clear.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: -1, height: 0.5)
        self.layer.shadowRadius = 0.5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func appIsArabic()->Bool{
        let language = Bundle.main.preferredLocalizations[0] as NSString
        if language.contains("ar"){
            return true
        }
        else{
            return false
        }
    }
    
    // func roundCorners() {
    //     self.layer.masksToBounds = false
    //     self.layer.cornerRadius = self.bounds.height/2
    //     self.clipsToBounds = true
    //  }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
}
