//
//  DetailsViewModel.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import UIKit
import RxSwift
import RxRelay

class DetailsViewModel : DetailsViewModelContract {
    
    var items = BehaviorRelay<[Movie]>(value: [])
    var groupedItems = BehaviorRelay<[CastingSection]>(value: [])

    var dataObservable: Observable<MovieDetailsModel>
    
    // Separate for details
    var detailsLoadingObservable: Observable<Bool>
    var detailsErrorObservable: Observable<String>
    
    // Separate for similar movies
    var similarLoadingObservable: Observable<Bool>
    var similarErrorObservable: Observable<String>
    
    // Separate for similar movies casting
    var castLoadingObservable: Observable<Bool>
    var castErrorObservable: Observable<String>
    
    private var dataSubject = PublishSubject<MovieDetailsModel>()
    private var errorDetailsSubject = PublishSubject<String>()
    private var errorSimilarSubject = PublishSubject<String>()
    private var errorCastSubject = PublishSubject<String>()
    private var loadingDetailsSubject = PublishSubject<Bool>()
    private var loadingSimilarSubject = PublishSubject<Bool>()
    private var loadingCastSubject = PublishSubject<Bool>()
    
    private let movieDetailsUsecase: MovieDetailsUsecaseContract
    private let similarMoviesUsecase: SimilarMoviesUsecaseContract
    private let moviesCastingUsecase: MoviesCastingUsecaseContract
    private let disposeBag = DisposeBag()

    var coordinator: CoordinatorProtocol
    var id: Int

    init(id: Int,
         movieDetailsUsecase: MovieDetailsUsecaseContract,
         similarMoviesUsecase: SimilarMoviesUsecaseContract,
         moviesCastingUsecase: MoviesCastingUsecaseContract,
         coordinator: CoordinatorProtocol
    ) {
        self.movieDetailsUsecase = movieDetailsUsecase
        self.similarMoviesUsecase = similarMoviesUsecase
        self.moviesCastingUsecase = moviesCastingUsecase
        self.coordinator = coordinator
        self.id = id

        self.dataObservable = dataSubject.asObservable()
        self.detailsLoadingObservable = loadingDetailsSubject.asObservable()
        self.detailsErrorObservable = errorDetailsSubject.asObservable()
        self.similarLoadingObservable = loadingSimilarSubject.asObservable()
        self.similarErrorObservable = errorSimilarSubject.asObservable()
        
        self.castLoadingObservable = loadingCastSubject.asObservable()
        self.castErrorObservable = errorCastSubject.asObservable()
        
        bindMovieDetails()
        bindSimilarMovies()
    }
    
    private func bindMovieDetails() {
        movieDetailsUsecase.dataObservable.subscribe(onNext: {[weak self] (movieDetails) in
            guard let self else {return}
            self.loadingDetailsSubject.onNext(false)
            self.dataSubject.onNext(movieDetails)
        }).disposed(by: disposeBag)
        
        movieDetailsUsecase.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self else {return}
            self.loadingDetailsSubject.onNext(false)
            self.errorDetailsSubject.onNext(message)
        }).disposed(by: disposeBag)
        
    }
    
    private func bindSimilarMovies() {
        similarMoviesUsecase.dataObservable.subscribe(onNext: {[weak self] (similarMovies) in
            guard let self else {return}
            self.loadingSimilarSubject.onNext(false)
            self.items.accept(similarMovies)
            self.setupSimilarCastingbyId(similars: similarMovies)
        }).disposed(by: disposeBag)
        
        similarMoviesUsecase.errorObservable.subscribe(onNext: {[weak self] _ in
            guard let self else {return}
            self.loadingSimilarSubject.onNext(false)
            self.errorSimilarSubject.onNext(Localize.General.errorGetSimilar)
        }).disposed(by: disposeBag)

    }
    
    func navigateTo(to: DestinationScreens) {
        coordinator.dismiss()
    }
    
    func fetchMovieDetails() {
        self.loadingDetailsSubject.onNext(true)
        movieDetailsUsecase.fetchData(id: id)
    }
    
    func fetchSimilarMovies() {
        self.loadingSimilarSubject.onNext(true)
        similarMoviesUsecase.fetchSimilarMovies(id: id)
    }
    
    func setupSimilarCastingbyId(similars: [Movie]) {
        loadingCastSubject.onNext(true)

        moviesCastingUsecase.fetchGroupedCastFromSimilars(similars)
            .subscribe(onNext: { [weak self] grouped in
                self?.groupedItems.accept(grouped)
                self?.loadingCastSubject.onNext(false)
            }, onError: { [weak self] _ in
                self?.errorCastSubject.onNext(Localize.General.errorGetCasting)
                self?.loadingCastSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
}

