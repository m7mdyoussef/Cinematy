//
//  MovieDetailsRemoteDatasourceContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation

protocol MovieDetailsRemoteDatasourceContract {
    func getMovieDetails(id: Int, language: String, completion: @escaping (Result<MovieDetailsModel, NSError>) -> Void)
    func getSimilarMovies(id: Int, language: String, completion: @escaping (Result<[Movie]?, NSError>) -> Void)
    func getSimilarMovieCastBy(id: Int, language: String, completion: @escaping (Result<[MovieCastModel]?, NSError>) -> Void)
}
