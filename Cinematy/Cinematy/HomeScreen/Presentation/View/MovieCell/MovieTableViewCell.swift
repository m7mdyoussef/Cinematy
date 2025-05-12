//
//  MovieTableViewCell.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell, CellViewProtocol {
    @IBOutlet private weak var MovieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieDescLabel: UILabel!
    @IBOutlet private weak var voteAvgLabel: UILabel!
    @IBOutlet private weak var voteCountLabel: UILabel!
    @IBOutlet private weak var wishListIconView: UIView!
    
    func setup(viewModel: BaseCellViewModelProtocol) {
        guard let viewModel = viewModel as? MovieTableViewCellModel else {return}
        MovieImageView.sd_setImage(with: URL(string: viewModel.image ), placeholderImage: .placeholderImage)
        movieNameLabel.text = viewModel.movieTitle
        movieDescLabel.text = viewModel.movieDesc
        voteAvgLabel.text = viewModel.rating
        voteCountLabel.text = viewModel.votingCount
        
        if LocalUserDefaults.sharedInstance.isInWishList(movieId: viewModel.id) {
            wishListIconView.isHidden = false
        }else{
            wishListIconView.isHidden = true
        }

    }
}
