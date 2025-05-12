//
//  BaseViewModelContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import RxSwift

protocol BaseViewModelContract{
    var errorObservable:Observable<(String)>{get}
    var loadingObservable: Observable<Bool> {get}
    var coordinator: CoordinatorProtocol {set get}
    func navigateTo(to: DestinationScreens)
}
