//
//  Constants.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

enum Constants{
    static let movieCellNibName = "MovieTableViewCell"
    static let castingCellNibName = "CastingTableViewCell"
    static let similarMovieCellNibName = "SimilarMovieCollectionViewCell"

    enum APIConstatnts {
        static let baseURL = "https://api.themoviedb.org/3/"
        
        static let popularMoviesUrlPath = "movie/popular"
        static let searchMoviesUrlPath = "search/movie"
        static let moviesDetailsUrlPath = "movie/%d"
        static let similarMoviesUrlPath = "movie/%d/similar"
        static let similarMovieCastUrlPath = "movie/%d/credits"
        
        static let includeAdults = "include_adult"
        static let includeVideo = "include_video"
        static let language = "language"
        static let page = "page"
        static let sortBy = "sort_by"
        static let query = "query"

        static let popularityDesc = "popularity.desc"
        static let imageURLPath = "https://image.tmdb.org/t/p/original"
    }
    
    enum userDefaultsKeys {
        static let wishListMovieIDs = "WishListMovieIDs"
    }
    
}

struct ParameterNames {
    static let movie_id = "movie_id"
}
