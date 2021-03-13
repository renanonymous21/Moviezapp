//
//  FavoriteMoviesModel.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import Foundation

struct FavoriteMoviesModel: Identifiable, Equatable {
    var id: Int
    var title: String
    var releaseDate: String
    var posterPath: String
    var status: String
    var overview: String
    var rating: Double
    
    static func ==(lhs: FavoriteMoviesModel, rhs: FavoriteMoviesModel) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.releaseDate == rhs.releaseDate
            && lhs.posterPath == rhs.posterPath
            && lhs.status == rhs.status
            && lhs.overview == rhs.overview
            && lhs.rating == rhs.rating
    }
    
}
