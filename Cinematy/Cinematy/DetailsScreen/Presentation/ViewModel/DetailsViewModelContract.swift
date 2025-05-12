//
//  DetailsViewModelContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift
import RxRelay

protocol DetailsViewModelContract {
    
    var detailsLoadingObservable: Observable<Bool>{get}
    var detailsErrorObservable: Observable<String>{get}

    var similarLoadingObservable: Observable<Bool>{get}
    var similarErrorObservable: Observable<String>{get}
    
    var castLoadingObservable: Observable<Bool>{get}
    var castErrorObservable: Observable<String>{get}
    
    var items: BehaviorRelay<[Movie]> {get set}
    var groupedItems: BehaviorRelay<[CastingSection]>{get set}
    var coordinator: CoordinatorProtocol {set get}

    var dataObservable:Observable<MovieDetailsModel>{get}
    
    func fetchMovieDetails()
    func fetchSimilarMovies()
    func navigateTo(to: DestinationScreens)
}
