//
//  CastingTableViewCellModel.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import RxDataSources

struct CastingTableViewCellModel: BaseCellViewModelProtocol {
    let image: String
    let castingTitle: String
    
    init(image: String, castingTitle: String) {
        self.image = Constants.APIConstatnts.imageURLPath + image
        self.castingTitle = castingTitle
    }
}

struct CastingSection {
    let department: String
    var casts: [MovieCastModel]
}

extension CastingSection: SectionModelType {
    typealias Item = MovieCastModel

    init(original: CastingSection, items: [MovieCastModel]) {
        self = original
        self.casts = items
    }

    var items: [MovieCastModel] {
        return casts
    }
}
