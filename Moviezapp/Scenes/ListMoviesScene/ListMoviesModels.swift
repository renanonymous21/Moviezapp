//
//  ListMoviesModels.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

// MARK:- Movies List related models

struct MoviesResponseModel: Codable {
    var page: Int
    var results: [MovieModel]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
    }
}

struct MovieModel: Identifiable, Codable {
    var id: Int
    var title: String?
    var releaseDate: String?
    var posterPath: String?
    var overview: String?
    var rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case overview
        case rating = "vote_average"
    }
}
