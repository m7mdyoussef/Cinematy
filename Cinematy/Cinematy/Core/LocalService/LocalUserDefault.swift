//
//  LocalUserDefaults.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

protocol LocalUserDefaultsContract {
    func saveWishList(movieId: Int)
    func removeFromWishList(movieId: Int)
    func isInWishList(movieId: Int) -> Bool
    func fetchWishList() -> [Int]
}


class LocalUserDefaults: LocalUserDefaultsContract {
    static let sharedInstance = LocalUserDefaults()
    private var userDefaults: UserDefaults
    private let wishListKey = Constants.userDefaultsKeys.wishListMovieIDs

    private init() {
        userDefaults = UserDefaults.standard
    }

    func saveWishList(movieId: Int) {
        var list = fetchWishList()
        guard !list.contains(movieId) else { return }
        list.append(movieId)
        userDefaults.set(list, forKey: wishListKey)
    }

    func removeFromWishList(movieId: Int) {
        var list = fetchWishList()
        list.removeAll { $0 == movieId }
        userDefaults.set(list, forKey: wishListKey)
    }

    func isInWishList(movieId: Int) -> Bool {
        return fetchWishList().contains(movieId)
    }

    func fetchWishList() -> [Int] {
        return userDefaults.array(forKey: wishListKey) as? [Int] ?? []
    }
}

