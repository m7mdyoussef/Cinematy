//
//  SimilarMoviesRepositoryImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift
import RxRelay

class SimilarMoviesRepositoryImp: SimilarMoviesRepositoryContract{
    private var errorsubject = PublishSubject<String>()
    private var dataSubject = PublishSubject<[Movie]>()
    private var movieDetailsRemoteDatasource: MovieDetailsRemoteDatasourceContract
    private let language = Locale.preferredLanguages[0]
    
    var errorObservable: Observable<(String)>
    var dataObservable:Observable<[Movie]>
    
    init(movieDetailsRemoteDatasource: MovieDetailsRemoteDatasourceContract) {
        errorObservable = errorsubject.asObservable()
        dataObservable = dataSubject.asObservable()

        
        self.movieDetailsRemoteDatasource = movieDetailsRemoteDatasource
    }
    
    func fetchData(id: Int) {
        movieDetailsRemoteDatasource.getSimilarMovies(id: id, language: language) {[weak self] result in
            guard let self else {return}
            switch result {
            case .success(let movieDetails):
                self.dataSubject.onNext(movieDetails ?? [])
            case .failure(let error):
                self.errorsubject.onNext(error.localizedDescription)
            }
        }
    }
    
}
