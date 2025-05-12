//
//  SimilarMovieCollectionViewCell.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import UIKit
import SDWebImage

class SimilarMovieCollectionViewCell: UICollectionViewCell, CellViewProtocol {

    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieName: UILabel!
    
    func setup(viewModel: BaseCellViewModelProtocol) {
        guard let viewModel = viewModel as? SimilarMovieCollectionViewCellModel else {return}
        movieImage.sd_setImage(with: URL(string: viewModel.image ), placeholderImage: .placeholderImage)
        movieName.text = viewModel.movieTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a red border with corner radius to the cell
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        // Make the image view fill the entire cell
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
    }

}
