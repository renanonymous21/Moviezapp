//
//  Entities.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

enum CoreDataEntities: String {
    case favoriteMovies = "FavoriteMovies"
    
    var value: String {
        return self.rawValue
    }
}
