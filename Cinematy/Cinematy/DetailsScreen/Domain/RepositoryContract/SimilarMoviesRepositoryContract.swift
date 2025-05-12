//
//  SimilarMoviesRepositoryContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift

protocol SimilarMoviesRepositoryContract {
    var dataObservable: Observable<[Movie]> {get}
    var errorObservable: Observable<(String)>{get}
    func fetchData(id: Int)
}
