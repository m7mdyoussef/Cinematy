//
//  SplashViewModelContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

protocol SplashViewModelContract {
    func navigateTo(to: DestinationScreens)
    var coordinator: CoordinatorProtocol {set get}
}
