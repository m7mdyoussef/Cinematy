//
//  SplashScreenViewModel.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

class SplashScreenViewModel: SplashViewModelContract {
    var coordinator: CoordinatorProtocol
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func navigateTo(to: DestinationScreens) {
        coordinator.navigateToNextScreen(destination: to)
    }
}
