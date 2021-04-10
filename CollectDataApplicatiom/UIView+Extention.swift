//
//  UIView+Extention.swift
//  ISChat
//
//  Created by Khaled Khaldi on 9/15/18.
//  Copyright © 2018 iPhoneAlsham. All rights reserved.
//

import UIKit

//@IBDesignable


extension UIStoryboard {
    func instanceVC<T: UIViewController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not locate viewcontroller with with identifier \(String(describing: T.self)) in storyboard.")
        }
        return vc
    }
    func instanceTabVC<T: UITabBarController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not locate viewcontroller with with identifier \(String(describing: T.self)) in storyboard.")
        }
        return vc
    }
}

//extension UIView {
//    
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            // layer.masksToBounds = newValue > 0
//        }
//    }
//    
//    // MARK: - Border
//    
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//        
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            guard let cgColor = layer.borderColor else { return nil }
//            return UIColor(cgColor: cgColor)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//    
//    
//    // MARK: - Shadow
//    
//    @IBInspectable var shadowColor: UIColor? {
//        get {
//            guard let cgColor = layer.shadowColor else { return nil }
//            return UIColor(cgColor: cgColor)
//        }
//        set {
//            layer.shadowColor = newValue?.cgColor
//        }
//    }
//    
//    @IBInspectable var shadowPath: CGPath? {
//        get {
//            return layer.shadowPath
//        }
//        set {
//            layer.shadowPath = newValue
//        }
//    }
//    
//    @IBInspectable var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
//    
//    @IBInspectable var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
//    
//    @IBInspectable var shadowOpacity: Float {
//        get {
//            return layer.shadowOpacity
//        }
//        set {
//            layer.shadowOpacity = newValue
//        }
//    }
//    
//
//    
//}
