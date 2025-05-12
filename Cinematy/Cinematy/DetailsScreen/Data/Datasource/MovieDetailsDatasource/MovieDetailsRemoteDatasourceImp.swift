//
//  MovieDetailsRemoteDatasourceImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import Alamofire

class MovieDetailsRemoteDatasourceImp : BaseAPI<ApplicationNetworking>, MovieDetailsRemoteDatasourceContract {
    
    func getMovieDetails(id: Int, language: String, completion: @escaping (Result<MovieDetailsModel, NSError>) -> Void) {
        self.fetchData(target: .getMovieDetails(id: id, language: language), responseClass: MovieDetailsModel.self) { result in
            switch result {
            case .success(let movieDetails):
                completion(.success(movieDetails))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSimilarMovies(id: Int, language: String, completion: @escaping (Result<[Movie]?, NSError>) -> Void) {
        self.fetchData(target: .getSimilarMovies(id: id, language: language), responseClass: MoviesModel.self) { result in
            switch result {
            case .success(let MoviesModel):
                let firstFiveMovies = MoviesModel.movies.prefix(5)
                completion(.success(Array(firstFiveMovies)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSimilarMovieCastBy(id: Int, language: String, completion: @escaping (Result<[MovieCastModel]?, NSError>) -> Void) {
        self.fetchData(target: .getSimilarMovieCastBy(id: id, language: language), responseClass: CastResponse.self) { result in
            switch result {
            case .success(let castResponse):
                completion(.success(castResponse.cast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
