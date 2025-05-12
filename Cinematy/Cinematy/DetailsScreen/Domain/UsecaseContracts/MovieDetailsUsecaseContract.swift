//
//  MovieDetailsUsecaseContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift

protocol MovieDetailsUsecaseContract {
    var dataObservable: Observable<MovieDetailsModel> {get}
    var errorObservable: Observable<(String)>{get}
    func fetchData(id: Int)
}
