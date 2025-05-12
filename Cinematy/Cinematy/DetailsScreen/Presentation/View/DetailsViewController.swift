//
//  DetailsViewController.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import UIKit
import SDWebImage
import RxSwift
import WebKit
import RxDataSources

class DetailsViewController: BaseViewController, WKNavigationDelegate{
    
    //MARK: - Outlets
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var tagLineLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var voteCountLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var storylineLabel: UILabel!
    @IBOutlet private weak var movieDescLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var budgetLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var movieHomePageLabel: UILabel!
    @IBOutlet private weak var similarLabel: UILabel!
    @IBOutlet private weak var similarMoviesCollectionView: UICollectionView!
    @IBOutlet private weak var castingLabel: UILabel!
    @IBOutlet private weak var castingTableView: UITableView!
    @IBOutlet weak var castingTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var addToWishListIcon: UIImageView!
    
    //MARK: - variables
    var detailsViewModel:DetailsViewModelContract!
    private var disposeBag:DisposeBag!
    private var movieDetails: MovieDetailsModel?
    private var dataSource: RxTableViewSectionedReloadDataSource<CastingSection>!
    
    private let similarMoviesSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let MoviesCastingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // castingTableView.isScrollEnabled = false
        disposeBag = DisposeBag()
        addWishlistGesture()
        registerCollectionCellNibFile()
        registerTableCellNibFile()
        instantiateRXItems()
        setupSimilarMoviesSpinner()
        setupCastingSpinner()
        showLoading()
        listenOnObservables()
        detailsViewModel.fetchMovieDetails()
        detailsViewModel.fetchSimilarMovies()
    }
    
    //MARK: - setup functions
    private func addWishlistGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(wishlistTapped))
        addToWishListIcon.isUserInteractionEnabled = true
        addToWishListIcon.addGestureRecognizer(tapGesture)
    }
    
    @objc private func wishlistTapped() {
        guard let movieId = movieDetails?.id else { return }
        let defaults = LocalUserDefaults.sharedInstance

        if defaults.isInWishList(movieId: movieId) {
            defaults.removeFromWishList(movieId: movieId)
        } else {
            defaults.saveWishList(movieId: movieId)
        }
        updateWishListIcon(id: movieId)
    }
    
    private func updateWishListIcon(id: Int) {
        let isSaved = LocalUserDefaults.sharedInstance.isInWishList(movieId: id)
        addToWishListIcon.image = isSaved ? .wished : .notWished
    }
    
    private func setupSimilarMoviesSpinner() {
        view.addSubview(similarMoviesSpinner)
        NSLayoutConstraint.activate([
            similarMoviesSpinner.centerXAnchor.constraint(equalTo: similarMoviesCollectionView.centerXAnchor),
            similarMoviesSpinner.centerYAnchor.constraint(equalTo: similarMoviesCollectionView.centerYAnchor)
        ])
    }
    
    private func setupCastingSpinner() {
        view.addSubview(MoviesCastingSpinner)
        NSLayoutConstraint.activate([
            MoviesCastingSpinner.centerXAnchor.constraint(equalTo: castingTableView.centerXAnchor),
            MoviesCastingSpinner.centerYAnchor.constraint(equalTo: castingTableView.centerYAnchor)
        ])
    }
    
    private func registerCollectionCellNibFile(){
        let similarMovieNibCell = UINib(nibName: Constants.similarMovieCellNibName, bundle: nil)
        similarMoviesCollectionView.register(similarMovieNibCell, forCellWithReuseIdentifier: Constants.similarMovieCellNibName)
    }
    
    private func registerTableCellNibFile(){
        let castNibCell = UINib(nibName: Constants.castingCellNibName, bundle: nil)
        castingTableView.register(castNibCell, forCellReuseIdentifier: Constants.castingCellNibName)
    }
    
    private func instantiateRXItems(){
        similarMoviesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        castingTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setUpSimilarMoviesAppearance(isHidden: Bool) {
        self.similarLabel.isHidden = isHidden
        self.similarMoviesCollectionView.isHidden = isHidden
        self.castingLabel.isHidden = isHidden
        self.castingTableView.isHidden = isHidden
    }
    
    private func setUpCastingAppearance(isHidden: Bool) {
        self.castingLabel.isHidden = isHidden
        self.castingTableView.isHidden = isHidden
    }
    
    //MARK: - Observe functions
    private func listenOnObservables(){
        detailsViewModel.detailsErrorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(title: Localize.General.alertTitle, body: message, actions: [UIAlertAction(title: Localize.General.ok, style: UIAlertAction.Style.default, handler: nil)])
            })
            .disposed(by: disposeBag)

        detailsViewModel.similarErrorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.setUpSimilarMoviesAppearance(isHidden: true)
                self?.showAlert(title: Localize.General.alertTitle, body: message, actions: [UIAlertAction(title: Localize.General.ok, style: UIAlertAction.Style.default, handler: nil)])
            })
            .disposed(by: disposeBag)
        
        detailsViewModel.castErrorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.setUpCastingAppearance(isHidden: true)
                self?.showAlert(title: Localize.General.alertTitle, body: message, actions: [UIAlertAction(title: Localize.General.ok, style: UIAlertAction.Style.default, handler: nil)])
            })
            .disposed(by: disposeBag)
        
        detailsViewModel.detailsLoadingObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.hideLoading()
            })
            .disposed(by: disposeBag)

        detailsViewModel.similarLoadingObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.similarMoviesSpinner.startAnimating() : self?.similarMoviesSpinner.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        detailsViewModel.castLoadingObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.MoviesCastingSpinner.startAnimating() : self?.MoviesCastingSpinner.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        detailsViewModel.dataObservable.subscribe (onNext: {[weak self] movieDetails in
            guard let self else {return}
            self.setData(movie: movieDetails)
        }).disposed(by: disposeBag)
        
        detailsViewModel.items
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] hasMovies in
                self?.setUpSimilarMoviesAppearance(isHidden: !hasMovies)
              
            })
            .disposed(by: disposeBag)
        
        detailsViewModel.groupedItems
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] hasCasting in
                self?.setUpCastingAppearance(isHidden: !hasCasting)
            })
            .disposed(by: disposeBag)
        
        detailsViewModel.items
            .observe(on: MainScheduler.instance)        
            .bind(to: similarMoviesCollectionView.rx.items(
                   cellIdentifier: Constants.similarMovieCellNibName,
                   cellType: SimilarMovieCollectionViewCell.self
            )) { row, item, cell in
                let model = SimilarMovieCollectionViewCellModel(
                    image: item.backdropPath ?? "",
                    movieTitle: item.title ?? ""
                )
                cell.setup(viewModel: model)
            }
            .disposed(by: disposeBag)
        
        
        dataSource = RxTableViewSectionedReloadDataSource<CastingSection>(
            configureCell: { _, tableView, indexPath, cast in
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.castingCellNibName, for: indexPath) as! CellViewProtocol
                let model = CastingTableViewCellModel(
                    image: cast.profilePath ?? "",
                    castingTitle: cast.name ?? "")
                cell.setup(viewModel: model)
                return cell as! UITableViewCell
            }
        )
        
        detailsViewModel.groupedItems
            .bind(to: castingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
//        detailsViewModel.groupedItems
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] _ in
//                self?.castingTableView.reloadData()
//                self?.updateCastingTableViewHeight()
//            })
//            .disposed(by: disposeBag)
        
    }
    
//    private func updateCastingTableViewHeight() {
//        // Ensure layout is completed before measuring
//        DispatchQueue.main.async {
//            self.castingTableView.layoutIfNeeded()
//            self.castingTableViewHeightConstraint.constant = self.castingTableView.contentSize.height
//        }
//    }
    
    //MARK: - set Movie Details Data
    private func setData(movie: MovieDetailsModel) {
        self.movieDetails = movie
        let imageURL = Constants.APIConstatnts.imageURLPath + (movie.backdropPath ?? "")
        movieImageView.sd_setImage(with: URL(string: imageURL ), placeholderImage: .placeholderImage)
        
        self.movieTitleLabel.text = movie.title

        if let movieId = movie.id {
            updateWishListIcon(id: movieId)
        }
        
        if let movieTagline = movie.tagline {
            self.tagLineLabel.text = movieTagline
            self.tagLineLabel.isHidden = false
        }

        if let movieVoteAverage = movie.voteAverage {
            self.ratingLabel.text  = "\(movieVoteAverage)/10"
            self.voteCountLabel.text = "\(Localize.MoviesHome.votes): \(movie.voteCount ?? 0)"
            self.ratingView.isHidden = false
        }
        
        if let overview = movie.overview, !overview.isEmpty {
            self.storylineLabel.text = Localize.MovieDetails.storyline
            self.movieDescLabel.text = overview
            self.storylineLabel.isHidden = false
            self.movieDescLabel.isHidden = false
        }
        
        if let revenue = movie.revenue {
            self.budgetLabel.text = Localize.MovieDetails.revenue + ": \(revenue)$"
            self.budgetLabel.isHidden = false
        }
        
        if let releaseDate = movie.releaseDate {
            self.dateLabel.text = Localize.MovieDetails.releaseDate + ": \(releaseDate)"
            self.dateLabel.isHidden = false
        }
        
        if let status = movie.status {
            self.statusLabel.text = Localize.MovieDetails.status + ": \(status)"
            self.statusLabel.isHidden = false
        }

        if let homepage = movie.homepage, !homepage.isEmpty {
            self.movieHomePageLabel.isHidden = false
            makeHyperLink(link: homepage)
        }
        
        similarLabel.text = Localize.MovieDetails.similar
        castingLabel.text = Localize.MovieDetails.casting
        
    }
}

// MARK: - Similar Movies Collection
extension DetailsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 133, height: 229)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - Casting Headers
extension DetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.textColor = .white
        headerLabel.backgroundColor = .black
        headerLabel.text = dataSource[section].department

        let headerView = UIView()
        headerView.backgroundColor = .black
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - HyperLink
extension DetailsViewController {
  
    private func makeHyperLink(link: String) {
        let attributedString = NSMutableAttributedString(string: link)
        let url = URL(string: link)!
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, attributedString.length))
        
        movieHomePageLabel.attributedText = attributedString
        movieHomePageLabel.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer to handle link tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        movieHomePageLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        guard let  text = movieHomePageLabel.attributedText?.string else { return }
        let webViewController = WebViewController(url: URL(string: text)!)
        present(webViewController, animated: true, completion: nil)
    }
}
