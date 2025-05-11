//
//  PaginationContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import RxSwift
import RxRelay
protocol PaginationContract {
    var items: BehaviorRelay<[Movie]> {get}
    var fetchMoreDatas: PublishSubject<String?>{get set}

    var refreshControlCompelted : PublishSubject<Void> {get}
    var isLoadingSpinnerAvaliable : PublishSubject<Bool> {get}
    var refreshControlAction : PublishSubject<String?> {get}
}
