//
//  SimilarMovieCollectionViewCellModel.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
struct SimilarMovieCollectionViewCellModel: BaseCellViewModelProtocol {
    let image: String
    let movieTitle: String
    
    init(image: String, movieTitle: String) {
        self.image = Constants.APIConstatnts.imageURLPath + image
        self.movieTitle = movieTitle
    }
}
