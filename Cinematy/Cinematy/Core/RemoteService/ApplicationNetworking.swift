//
//  ApplicationNetworking.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import Alamofire

enum ApplicationNetworking{
    case getMovies(page:String, language: String)
    case getSearchMovies(page:String, language: String, query: String)

    case getMovieDetails(id: Int, language: String)
    case getSimilarMovies(id: Int, language: String)
    case getSimilarMovieCastBy(id: Int, language: String)

}

extension ApplicationNetworking : TargetType{
    var baseURL: String {
        switch self{
        default:
            return Constants.APIConstatnts.baseURL
        }
    }
    
    var path: String {
        switch self{
        case .getMovies:
            return Constants.APIConstatnts.popularMoviesUrlPath
        case .getSearchMovies:
            return Constants.APIConstatnts.searchMoviesUrlPath
        case .getMovieDetails(let id, _):
            return String(format: Constants.APIConstatnts.moviesDetailsUrlPath, id)
        case .getSimilarMovies(let id, _):
            return String(format: Constants.APIConstatnts.similarMoviesUrlPath, id)
        case .getSimilarMovieCastBy(let id, _):
            return String(format: Constants.APIConstatnts.similarMovieCastUrlPath, id)
        }
    }
    
    var method: HTTPMethod {
        switch self{
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .getMovies(let page, let language):
            return .requestParameters(parameters:
                                        [Constants.APIConstatnts.includeAdults: false,
                                         Constants.APIConstatnts.includeVideo: false,
                                         Constants.APIConstatnts.language: language,
                                         Constants.APIConstatnts.page: page,
                                         Constants.APIConstatnts.sortBy: Constants.APIConstatnts.popularityDesc
                                        ],
                                      encoding: URLEncoding.default)
            
            
        case .getSearchMovies(page: let page, language: let language, query: let query):
            return .requestParameters(parameters:
                                        [Constants.APIConstatnts.includeAdults: false,
                                         Constants.APIConstatnts.includeVideo: false,
                                         Constants.APIConstatnts.language: language,
                                         Constants.APIConstatnts.page: page,
                                         Constants.APIConstatnts.sortBy: Constants.APIConstatnts.popularityDesc,
                                         Constants.APIConstatnts.query: query
                                        ],
                                      encoding: URLEncoding.default)
            
        case .getMovieDetails(_, let language):
            return .requestParameters(parameters:
                                        [Constants.APIConstatnts.language:language],
                                      encoding: URLEncoding.default)
            
        case .getSimilarMovies(_, let language):
            return .requestParameters(parameters:
                                        [Constants.APIConstatnts.language:language],
                                      encoding: URLEncoding.default)
            
        case .getSimilarMovieCastBy(_, let language):
            return .requestParameters(parameters:
                                        [Constants.APIConstatnts.language:language],
                                      encoding: URLEncoding.default)

        }
    }
    var headers: [String : String]? {
        switch self{
        default:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": Bundle.main.TMDBKey
            ]
        }
    }
}
