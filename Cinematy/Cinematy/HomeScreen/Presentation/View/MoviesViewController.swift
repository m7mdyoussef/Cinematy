//
//  MoviesViewController.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class MoviesViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var moviesTableView: UITableView!
    
    //MARK: - variables
    var moviesViewModel: MoviesViewModelContract!
    private var disposeBag: DisposeBag!
    private var dataSource: RxTableViewSectionedReloadDataSource<MovieSection>!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupSearchController()
        registerCellNibFile()
        instantiateRXItems()
        listenOnObservables()
        instantiateRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = Localize.appName
    }
    
    //MARK: - setup functions
    private func setupNavigationController(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    private func instantiateRefreshControl(){
        moviesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    
    private func registerCellNibFile(){
        let movieNibCell = UINib(nibName: Constants.movieCellNibName, bundle: nil)
        moviesTableView.register(movieNibCell, forCellReuseIdentifier: Constants.movieCellNibName)
    }
    
    private func instantiateRXItems(){
        disposeBag = DisposeBag()
        moviesTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    @objc private func refreshControlTriggered() {
        moviesViewModel.triggerRefresh()
    }
    
    //MARK: - Observe functions
    private func listenOnObservables(){
        moviesViewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self else { return }
            self.showAlert(title: Localize.General.alertTitle, body: message, actions: [UIAlertAction(title: Localize.General.ok, style: UIAlertAction.Style.default, handler: nil)])
        }).disposed(by: disposeBag)
        
        moviesViewModel.loadingObservable.subscribe(onNext: {[weak self] (isLoading) in
            guard let self else { return }
            isLoading ? self.showLoading() : self.hideLoading()
        }).disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource<MovieSection>(
            configureCell: { _, tableView, indexPath, movie in
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellNibName, for: indexPath) as! CellViewProtocol
                let model = MovieTableViewCellModel(
                    id: movie.id ?? 0,
                    image: movie.backdropPath ?? "",
                    movieTitle: movie.title ?? "",
                    movieDesc: movie.overview ?? "",
                    rating: movie.voteAverage ?? 0.0,
                    votingCount: movie.voteCount ?? 0)
                cell.setup(viewModel: model)
                return cell as! UITableViewCell
            }
        )
        
        moviesViewModel.groupedItems
            .bind(to: moviesTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        moviesTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self else { return }
            let offSetY = self.moviesTableView.contentOffset.y
            let contentHeight = self.moviesTableView.contentSize.height
            
            if offSetY > (contentHeight - self.moviesTableView.frame.size.height - 20) {
                self.moviesViewModel.triggerFetchMore()
            }
        }.disposed(by: disposeBag)
        
        moviesViewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self else { return }
            isAvaliable ? self.showLoading() : self.hideLoading()
        }
        .disposed(by: disposeBag)
        
        moviesViewModel.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
        
        moviesTableView.rx.modelSelected(Movie.self).subscribe(onNext: {[weak self] (MovieItem) in
            guard let self = self else {return}
            self.moviesViewModel.navigateTo(to: .Details(MovieItem.id ?? 1))
        }).disposed(by: disposeBag)
    }
}

// MARK: - UISearchResultsUpdating
extension MoviesViewController: UISearchResultsUpdating {
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localize.MoviesHome.searchMovies
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchResultsUpdater = self // to handle live updates
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            moviesViewModel.searchQuery.accept(nil)
            return
        }
        moviesViewModel.searchQuery.accept(searchText)
        
    }
}

// MARK: - UITableViewDelegate
extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        headerLabel.textColor = .homeBackground
        headerLabel.backgroundColor = .gray
        headerLabel.text = dataSource[section].year
        
        let headerView = UIView()
        headerView.backgroundColor = .gray
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 4),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
