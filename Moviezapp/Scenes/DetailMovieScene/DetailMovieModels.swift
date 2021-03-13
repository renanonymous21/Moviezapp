//
//  DetailMovieModels.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import Foundation

// MARK:- Detauk movie model

struct DetailMovieModel: Identifiable, Codable {
    var id: Int
    var title: String
    var releaseDate: String
    var posterPath: String
    var status: String
    var overview: String
    var rating: Double
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id,
             title,
             status,
             overview,
             releaseDate = "release_date",
             posterPath = "poster_path",
             rating = "vote_average"
    }
}

// MARK:- Reviews-related Model

struct ReviewsResponseModel: Identifiable, Codable {
    var id: Int
    var results: [ReviewsModel]
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case results
        case totalPages = "total_pages"
    }
}

struct ReviewsModel: Identifiable, Codable {
    var id: String
    var author: String
    var authorDetails: AuthorDetailModel
    var content: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id,
             author,
             authorDetails = "author_details",
             content,
             createdAt = "created_at",
             updatedAt = "updated_at"
    }
}

struct AuthorDetailModel: Codable {
    var name: String
    var username: String
    var avatarPath: String
    var rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case name,
             username,
             avatarPath = "avatar_path",
             rating
    }
}
