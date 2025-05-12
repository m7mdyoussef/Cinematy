//
//  CastingTableViewCell.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import UIKit

class CastingTableViewCell: UITableViewCell, CellViewProtocol {

    @IBOutlet private weak var castingImage: UIImageView!
    @IBOutlet private weak var castingNameLable: UILabel!
    
    func setup(viewModel: BaseCellViewModelProtocol) {
        guard let viewModel = viewModel as? CastingTableViewCellModel else {return}
        castingImage.sd_setImage(with: URL(string: viewModel.image ), placeholderImage: .placeholderImage)
        castingNameLable.text = viewModel.castingTitle
    }
    
}
