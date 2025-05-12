//
//  MoviesRepositoryContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import RxSwift

protocol MoviesRepositoryContract{
    func getMovies(page: Int, query: String?, completion: @escaping (Result<MoviesModel?, NSError>) -> Void)
    func cancelAllRequests()
}
