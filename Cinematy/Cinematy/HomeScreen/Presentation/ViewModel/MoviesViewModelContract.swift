//
//  MoviesViewModelContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import RxSwift
import RxRelay

protocol MoviesViewModelContract : BaseViewModelContract,PaginationContract {
    var items: BehaviorRelay<[Movie]> {get set}
    var groupedItems: BehaviorRelay<[MovieSection]> {get set}
    var searchQuery: BehaviorRelay<String?>  { get set}
    func triggerRefresh()
    func triggerFetchMore()
}
