//
//  MoviesCastingUsecaseContract.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift

protocol MoviesCastingUsecaseContract {
    var dataObservable: Observable<[MovieCastModel]> {get}
    var errorObservable: Observable<(String)>{get}
    func fetchGroupedCastFromSimilars(_ similars: [Movie]) -> Observable<[CastingSection]>

}
