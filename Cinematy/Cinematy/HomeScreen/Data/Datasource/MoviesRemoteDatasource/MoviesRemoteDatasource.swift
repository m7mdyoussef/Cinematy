//
//  MoviesRemoteDatasource.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import Alamofire

class MoviesRemoteDatasource : BaseAPI<ApplicationNetworking>, MoviesRemoteDatasourceContract{

    func getMovies(page: String, language: String, completion: @escaping (Result<MoviesModel?, NSError>) -> Void) {
        self.fetchData(target: .getMovies(page: page, language: language), responseClass: MoviesModel.self) { (result) in
            switch result {
            case .success(let movieModel):
                completion(.success(movieModel))
            case .failure(let error):
                completion(.failure(error))

            }
        }
    }
    
    func getSearchedMovies(page: String, language: String, query: String, completion: @escaping (Result<MoviesModel?, NSError>) -> Void) {
        self.fetchData(target: .getSearchMovies(page: page, language: language, query: query), responseClass: MoviesModel.self) { (result) in
            switch result {
            case .success(let movieModel):
                completion(.success(movieModel))
            case .failure(let error):
                completion(.failure(error))

            }
        }
    }
    
        
    func cancelAllRequests() {
        self.cancelAnyRequest()
    }

}

   
