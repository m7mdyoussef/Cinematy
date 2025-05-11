//
//  StoryBoardsEnum.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit

enum StoryBoardsEnum : String {
    case Splash = "SplashViewController"
    case Movies = "MoviesViewController"
    case Details = "DetailsViewController"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) ->T {
        let storyBoardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
}

