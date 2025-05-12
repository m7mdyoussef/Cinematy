//
//  MoviesViewModel.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation
import RxSwift
import RxRelay

class MoviesViewModel: MoviesViewModelContract {
    
    private let usecase: MoviesUsecasContract
    private let disposeBag = DisposeBag()
    var coordinator: CoordinatorProtocol

    var items = BehaviorRelay<[Movie]>(value: [])
    var groupedItems = BehaviorRelay<[MovieSection]>(value: [])
    var searchQuery = BehaviorRelay<String?>(value: nil)

    var fetchMoreDatas = PublishSubject<String?>()
    let refreshControlAction = PublishSubject<String?>()
    let refreshControlCompelted = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    let errorObservable: Observable<String>
    let loadingObservable: Observable<Bool>

    init(coordinator: CoordinatorProtocol, usecase: MoviesUsecasContract) {
        self.coordinator = coordinator
        self.usecase = usecase

        self.errorObservable = usecase.errorObservable
        self.loadingObservable = usecase.loadingObservable

        bind()
    }

    private func bind() {
        searchQuery
            .distinctUntilChanged()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.refreshControlAction.onNext(query)
            })
            .disposed(by: disposeBag)

        fetchMoreDatas
            .bind(to: usecase.fetchMoreDatas)
            .disposed(by: disposeBag)

        refreshControlAction
            .bind(to: usecase.refreshControlAction)
            .disposed(by: disposeBag)

        usecase.dataObservable
            .subscribe(onNext: { [weak self] movies in
                self?.items.accept(movies)
                self?.groupedItems.accept(self?.groupByYear(movies) ?? [])
            })
            .disposed(by: disposeBag)

        usecase.refreshControlCompelted
            .bind(to: refreshControlCompelted)
            .disposed(by: disposeBag)

        usecase.isLoadingSpinnerAvaliable
            .bind(to: isLoadingSpinnerAvaliable)
            .disposed(by: disposeBag)
    }

    func triggerRefresh() {
        refreshControlAction.onNext(searchQuery.value)
    }

    func triggerFetchMore() {
        fetchMoreDatas.onNext(searchQuery.value)
    }

    func navigateTo(to: DestinationScreens) {
        if case .Details(let id) = to {
            coordinator.navigateToNextScreen(destination: .Details(id))
        }
    }
}

extension MoviesViewModel {
    private func groupByYear(_ movies: [Movie]) -> [MovieSection] {
        let grouped = Dictionary(grouping: movies) { movie -> String in
            movie.releaseDate?.split(separator: "-").first.map(String.init) ?? "Unknown"
        }
        return grouped.map { MovieSection(year: $0.key, movies: $0.value) }
            .sorted { $0.year > $1.year }
    }
}
