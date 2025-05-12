//
//  Injector.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit

class Injector {
    
    static func getSplashViewController(coordinator: CoordinatorProtocol) -> SplashViewController {
        let viewModel = SplashScreenViewModel(coordinator: coordinator)
        let viewcontroller = SplashViewController.instantiateFromStoryBoard(appStoryBoard: .Splash)
        viewcontroller.viewModel = viewModel
        return viewcontroller
    }

    static func getMoviesViewController(coordinator: CoordinatorProtocol) -> MoviesViewController {
        let remoteDatasource = MoviesRemoteDatasource()
        let repo = MoviesRepositoryImp(remote: remoteDatasource)
        let usecase = MoviesUsecaseImp(repo: repo)
        let viewModel = MoviesViewModel(coordinator: coordinator, usecase: usecase)
        let viewcontroller = MoviesViewController.instantiateFromStoryBoard(appStoryBoard: .Movies)
        viewcontroller.moviesViewModel = viewModel
        return viewcontroller
    }

}
