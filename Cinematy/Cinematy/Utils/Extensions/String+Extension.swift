//
//  String.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//

import Foundation

extension String {
    var localize: String {
        let value = NSLocalizedString(self, comment: "")
        return value
    }
}
