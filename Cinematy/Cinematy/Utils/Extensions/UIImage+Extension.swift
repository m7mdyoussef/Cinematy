//
//  UIImage.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit

extension UIImage {
    static var emptyImage: UIImage {
        return UIImage()
    }
    
    static var backButton: UIImage {
        return UIImage(systemName: "chevron.backward.circle") ?? .emptyImage
    }
    
    static var wished: UIImage {
        return UIImage(named: "wishListFill") ?? .emptyImage
    }
    
    static var notWished: UIImage {
        return UIImage(named: "wishListEmpty") ?? .emptyImage
    }
    
    static var placeholderImage: UIImage {
        return UIImage(named: "placeholder") ?? .emptyImage
    }
}
