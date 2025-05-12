//
//  MovieDetailsUsecaseImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailsUsecaseImp: MovieDetailsUsecaseContract {
    private var errorsubject = PublishSubject<String>()
    private var dataSubject = PublishSubject<MovieDetailsModel>()
    private var disposeBag: DisposeBag
    private let repo: MovieDetailsRepositoryContract

    var dataObservable: Observable<MovieDetailsModel>
    var errorObservable: Observable<(String)>
    var fetchMoreDatas: PublishSubject<Void>
    
    init(
        repo: MovieDetailsRepositoryContract
    ) {
        self.repo = repo
        errorObservable = errorsubject.asObservable()
        dataObservable = dataSubject.asObservable()
        
        fetchMoreDatas = PublishSubject<Void>()
        
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
    
    func fetchData(id: Int) {
        repo.fetchData(id: id)
    }
        
}
