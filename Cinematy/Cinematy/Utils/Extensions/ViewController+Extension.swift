//
//  UIViewController.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit

extension UIViewController {
    
    static func instantiateFromStoryBoard(appStoryBoard : StoryBoardsEnum) -> Self {
        return appStoryBoard.viewController(viewControllerClass: self)
    }
    
    class var storyboardID : String {
        return "\(self)"
    }

}
