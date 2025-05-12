//
//  MoviesUsecaseImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesUsecaseImp: MoviesUsecasContract {
        
    private let repo: MoviesRepositoryContract
    private let disposeBag = DisposeBag()
    private var page = 1
    private var totalPages = Int.max
    private var isFetching = false

    var items = BehaviorRelay<[Movie]>(value: [])
    private let loadingSubject = PublishSubject<Bool>()
    private let errorSubject = PublishSubject<String>()
    private let refreshCompletedSubject = PublishSubject<Void>()
    private let spinnerVisibleSubject = PublishSubject<Bool>()

    var dataObservable: Observable<[Movie]> { items.asObservable() }
    var loadingObservable: Observable<Bool> { loadingSubject.asObservable() }
    var errorObservable: Observable<String> { errorSubject.asObservable() }
    var refreshControlCompelted: PublishSubject<Void> { refreshCompletedSubject }
    var isLoadingSpinnerAvaliable: PublishSubject<Bool> { spinnerVisibleSubject }

    var fetchMoreDatas = PublishSubject<String?>()
    let refreshControlAction = PublishSubject<String?>()

    init(repo: MoviesRepositoryContract) {
        self.repo = repo
        bind()
    }

    private func bind() {
        fetchMoreDatas
            .subscribe(onNext: { [weak self] query in
                self?.fetchMovies(isRefresh: false, query: query)
            })
            .disposed(by: disposeBag)

        refreshControlAction
            .subscribe(onNext: { [weak self] query in
                self?.refreshMovies(query: query)
            })
            .disposed(by: disposeBag)
    }

    private func refreshMovies(query: String?) {
        repo.cancelAllRequests()
        page = 1
        totalPages = Int.max
        items.accept([])
        fetchMovies(isRefresh: true, query: query)
    }

    private func fetchMovies(isRefresh: Bool, query: String?) {
        guard !isFetching, page <= totalPages else { return }
        isFetching = true
        loadingSubject.onNext(true)
        spinnerVisibleSubject.onNext(page != 1 && !isRefresh)

        repo.getMovies(page: page, query: query) { [weak self] result in
            guard let self else { return }
            self.loadingSubject.onNext(false)
            self.spinnerVisibleSubject.onNext(false)
            self.isFetching = false

            switch result {
            case .success(let model):
                self.totalPages = model?.totalPages ?? Int.max
                var currentData = self.items.value
                if isRefresh {
                    currentData = model?.movies ?? []
                } else {
                    currentData += model?.movies ?? []
                }
                self.items.accept(currentData)
                self.page += 1
            case .failure(let error):
                if error.code != NSURLErrorCancelled {
                    self.errorSubject.onNext(error.localizedDescription)
                }
            }
            self.refreshCompletedSubject.onNext(())
        }
    }
}
