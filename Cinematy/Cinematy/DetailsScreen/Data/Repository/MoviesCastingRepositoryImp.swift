//
//  MoviesCastingRepositoryImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift
import RxRelay

class MoviesCastingRepositoryImp: MoviesCastingRepositoryContract{
    private var errorsubject = PublishSubject<String>()
    private var dataSubject = PublishSubject<[MovieCastModel]>()
    private var movieDetailsRemoteDatasource: MovieDetailsRemoteDatasourceContract
    private let language = Locale.preferredLanguages[0]
    
    var errorObservable: Observable<(String)>
    var dataObservable:Observable<[MovieCastModel]>
    
    init(movieDetailsRemoteDatasource: MovieDetailsRemoteDatasourceContract) {
        errorObservable = errorsubject.asObservable()
        dataObservable = dataSubject.asObservable()

        
        self.movieDetailsRemoteDatasource = movieDetailsRemoteDatasource
    }
    
    func fetchData(id: Int) -> Observable<[MovieCastModel]> {
        return Observable.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }

         movieDetailsRemoteDatasource.getSimilarMovieCastBy(id: id, language: language) { result in
             switch result {
                case .success(let castDetails):
                    observer.onNext(castDetails ?? [])
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
    
}
