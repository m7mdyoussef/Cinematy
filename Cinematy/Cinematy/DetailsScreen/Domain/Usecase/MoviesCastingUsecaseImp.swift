//
//  MoviesCastingUsecaseImp.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesCastingUsecaseImp: MoviesCastingUsecaseContract {
    
    private var errorsubject = PublishSubject<String>()
    private var dataSubject = PublishSubject<[MovieCastModel]>()
    private var disposeBag: DisposeBag
    private let repo: MoviesCastingRepositoryContract

    var dataObservable: Observable<[MovieCastModel]>
    var errorObservable: Observable<(String)>
    var fetchMoreDatas: PublishSubject<Void>
    var refreshControlCompelted: PublishSubject<Void>
    var isLoadingSpinnerAvaliable: PublishSubject<Bool>
    var refreshControlAction: PublishSubject<Void>
    
    init(
        repo: MoviesCastingRepositoryContract
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
        repo.dataObservable.subscribe(onNext: {[weak self] (castDetails) in
            guard let self else {return}
            self.dataSubject.onNext(castDetails)
        }).disposed(by: disposeBag)
        
        repo.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self else {return}
            self.errorsubject.onNext(message)
        }).disposed(by: disposeBag)
        
    }
    
   private func fetchData(id: Int) -> Observable<[MovieCastModel]> {
        return repo.fetchData(id: id)
    }
    
    func fetchGroupedCastFromSimilars(_ similars: [Movie]) -> Observable<[CastingSection]> {
        guard !similars.isEmpty else {
            return Observable.just([])
        }

        return Observable.from(similars)
            .compactMap { $0.id }
            .flatMap { movieId -> Observable<[MovieCastModel]> in
                self.fetchData(id: movieId) // assumes fetchData returns Observable<[MovieCastModel]>
                    .catch { error in
                        return Observable.just([]) // Handle per-movie error silently
                    }
            }
            .toArray()
            .map { allCasts in
                let flat = allCasts.flatMap { $0 }
                return self.groupCastByCategory(flat)
            }
            .asObservable()
    }
    
    private func groupCastByCategory(_ cast: [MovieCastModel]) -> [CastingSection] {
        
        let topActing = cast
            .filter { $0.knownForDepartment == departement.Acting.rawValue }
            .sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
            .prefix(5)

        let topDirecting = cast
            .filter { $0.knownForDepartment == departement.Directing.rawValue }
            .sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
            .prefix(5)

        
        let filteredCast: [MovieCastModel] = Array(topActing + topDirecting)
        
        let groupedDict = Dictionary(grouping: filteredCast) { filteredCast -> String in
            return filteredCast.knownForDepartment ?? ""
        }
        
        return groupedDict
            .map { CastingSection(department: $0.key, casts: $0.value) }
            .sorted {
                ($0.casts.first?.popularity ?? 0) > ($1.casts.first?.popularity ?? 0)
            }
    }

        
}
