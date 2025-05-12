//
//  MovieTableViewCellModel.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

struct MovieTableViewCellModel: BaseCellViewModelProtocol {
    let id: Int
    let image: String
    let movieTitle: String
    let movieDesc: String
    let rating: String
    let votingCount: String
    
    init(id: Int, image: String, movieTitle: String, movieDesc: String, rating: Double, votingCount: Int) {
        self.id = id
        self.image = Constants.APIConstatnts.imageURLPath + image
        self.movieTitle = movieTitle
        self.movieDesc = movieDesc
        self.rating  = "\(rating)/10"
        self.votingCount = "\(Localize.MoviesHome.votes): \(votingCount)"
    }
}

class x:BaseCellViewModelProtocol  {
    let m:String
    
    init(m: String) {
        self.m = m
    }
}
