//
//  SimilarMoviesUsecaseImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift
import RxCocoa

class SimilarMoviesUsecaseImp: SimilarMoviesUsecaseContract {
    
    private var errorsubject = PublishSubject<String>()
    private var dataSubject = PublishSubject<[Movie]>()
    private var disposeBag: DisposeBag
    private let repo: SimilarMoviesRepositoryContract

    var dataObservable: Observable<[Movie]>
    var errorObservable: Observable<(String)>
    var fetchMoreDatas: PublishSubject<Void>
    var refreshControlCompelted: PublishSubject<Void>
    var isLoadingSpinnerAvaliable: PublishSubject<Bool>
    var refreshControlAction: PublishSubject<Void>
    
    init(
        repo: SimilarMoviesRepositoryContract
    ) {
        self.repo = repo
        errorObservable = errorsubject.asObservable()
        dataObservable = dataSubject.asObservable()
        
        fetchMoreDatas = PublishSubject<Void>()
        refreshControlAction = PublishSubject<Void>()
        refreshControlCompelted = PublishSubject<Void>()
        isLoadingSpinnerAvaliable = PublishSubject<Bool>()
        
        disposeBag = DisposeBag()
        
        bind()
    }
    
    private func bind() {
        repo.dataObservable.subscribe(onNext: {[weak self] (movieDetails) in
            guard let self else {return}
            self.dataSubject.onNext(movieDetails)
        }).disposed(by: disposeBag)
        
        repo.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self else {return}
            self.errorsubject.onNext(message)
        }).disposed(by: disposeBag)
        
    }
    
    func fetchSimilarMovies(id: Int) {
        repo.fetchData(id: id)
    }
        
}
