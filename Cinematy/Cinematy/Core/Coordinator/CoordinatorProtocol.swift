//
//  CoordinatorProtocol.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
    func navigateToNextScreen(destination: DestinationScreens)
    func dismiss()
    func navigateToRoot()
}


enum DestinationScreens{
    case Splash
    case Home
    case Details(Int)
}
