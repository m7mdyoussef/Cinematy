//
//  SimilarMoviesUsecaseContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//


import Foundation
import RxSwift

protocol SimilarMoviesUsecaseContract {
    var dataObservable: Observable<[Movie]> {get}
    var errorObservable: Observable<(String)>{get}
    func fetchSimilarMovies(id: Int)
}
