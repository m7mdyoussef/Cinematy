//
//  MoviesRepositoryImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import RxSwift
import RxRelay

class MoviesRepositoryImp: MoviesRepositoryContract {
    private let remote: MoviesRemoteDatasourceContract
    private let language = Locale.preferredLanguages[0]

    init(remote: MoviesRemoteDatasourceContract) {
        self.remote = remote
    }

    func getMovies(page: Int, query: String?, completion: @escaping (Result<MoviesModel?, NSError>) -> Void) {
        if let query = query, !query.isEmpty {
            remote.getSearchedMovies(page: String(page), language: language, query: query, completion: completion)
        } else {
            remote.getMovies(page: String(page), language: language, completion: completion)
        }
    }

    func cancelAllRequests() {
        remote.cancelAllRequests()
    }
}
