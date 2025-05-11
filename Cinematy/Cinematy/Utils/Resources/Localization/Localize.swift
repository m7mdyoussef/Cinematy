//
//  Localize.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

enum Localize {
    static let appName = "appName".localize

    enum General {
        static let genericError = "genericError".localize
        static let alertTitle = "alertTitle".localize
        static let ok = "ok".localize
        static let noInternetConnection = "noInternetConnection".localize
        static let errorGetCasting = "errorGetCastingList".localize
        static let errorGetSimilar = "errorGetSimilarList".localize

    }
    
    enum Splash {
        static let welcomeTo = "welcome_to".localize
    }
    
    enum MoviesHome {
        static let votes = "votes".localize
    }
    
    enum MovieDetails {
        static let storyline = "storyline".localize
        static let releaseDate = "releaseDate".localize
        static let revenue = "revenue".localize
        static let status = "Status".localize
        static let similar = "Similar".localize
        static let casting = "Casting".localize
    }
}
