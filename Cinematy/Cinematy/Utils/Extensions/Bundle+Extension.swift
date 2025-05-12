//
//  Bundle.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

extension Bundle {
    func value<T>(for key: String) -> T? {
        object(forInfoDictionaryKey: key) as? T
    }
    
    var TMDBKey: String {
        value(for: "TMDBKey").orEmpty
    }
}


extension Optional where Wrapped == String {
    var orEmpty: String {
        return self?.isEmpty ?? true ? "" : self!
    }
}
