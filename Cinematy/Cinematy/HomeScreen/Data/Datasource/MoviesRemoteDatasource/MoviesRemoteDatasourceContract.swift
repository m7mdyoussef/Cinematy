//
//  MoviesRemoteDatasourceContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
protocol MoviesRemoteDatasourceContract {
    func getMovies(page: String, language: String, completion: @escaping (Result<MoviesModel?,NSError>) -> Void)
    func getSearchedMovies(page: String, language: String, query: String, completion: @escaping (Result<MoviesModel?,NSError>) -> Void)
    func cancelAllRequests()
}
