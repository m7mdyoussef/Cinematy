//
//  AppCoordinator.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let nextViewController = Injector.getSplashViewController(coordinator: self)
        navigationController.pushViewController(nextViewController, animated: false)
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: true)
        }
    }
    
    func navigateToRoot() {
        DispatchQueue.main.async {
            self.navigationController.popToRootViewController(animated: true)
            self.navigationController.dismiss(animated: true)
        }
    }
            
    func navigateToNextScreen(destination: DestinationScreens){
        switch destination{
        case .Splash:
            start()
        case .Home:
            openMoviesScreen()
        case .Details(let id):
            openMovieDetailsScreen(id: id)
        }
        
    }
    
    private func openMoviesScreen() {
        let nextViewController = Injector.getMoviesViewController(coordinator: self)
        navigationController.pushViewController(nextViewController, animated: false)
    }
    
    private func openMovieDetailsScreen(id: Int) {
        let nextViewController = Injector.getMovieDetailsViewController(coordinator: self, id: id)
        navigationController.pushViewController(nextViewController, animated: true)
    }
}
