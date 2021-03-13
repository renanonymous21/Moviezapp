//
//  MoviesTests.swift
//  MoviezappTests
//
//  Created by Rendy K. R on 13/03/21.
//

import XCTest
@testable import Moviezapp

class MoviesTests: XCTestCase {

    let listMoviesViewModel = ListMoviesViewModel()
    let detailMovieViewModel = DetailMovieViewModel(movieId: 587807)
    let favoriteViewModel = FavoriteMoviesViewModel()
    
    // MARK:- DTO with json file

    func testMovieModelDTO() throws {
        guard let json = Bundle(for: type(of: self)).path(forResource: "MovieResponse", ofType: "json")
        else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: json), options: .mappedIfSafe)
            let decode = try JSONDecoder().decode(MoviesResponseModel.self, from: data)
            
            XCTAssertEqual(decode.results.isEmpty, false)
        }
    }
    
    func testDetailMovieDTO() throws {
        guard let json = Bundle(for: type(of: self)).path(forResource: "DetailMovie", ofType: "json")
        else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: json), options: .mappedIfSafe)
            let decode = try JSONDecoder().decode(DetailMovieModel.self, from: data)
            XCTAssertEqual(decode.overview.isEmpty, false)
            if decode.id != 587807 {
                XCTAssertFalse(true, "error parsing json")
            }
        }
    }
    
    func testReviewsResponseModelDTO() throws {
        guard let json = Bundle(for: type(of: self)).path(forResource: "MovieReviews", ofType: "json")
        else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: json), options: .mappedIfSafe)
            let decode = try JSONDecoder().decode(ReviewsResponseModel.self, from: data)
            XCTAssertEqual(decode.results.isEmpty, false)
        }
    }
    
    // MARK:- List movies tests

    func testFetchListPopularMoviesFirstLoad() throws {
        listMoviesViewModel.fetchMovies(.popular, isFirstLoad: true)
        guard let isError = listMoviesViewModel.isError.value
        else {
            return
        }
        if isError {
            XCTAssertEqual(listMoviesViewModel.errorMessage.value??.isEmpty, true)
        } else {
            XCTFail(listMoviesViewModel.errorMessage.value!!)
        }
    }
    
    func testFetchListUpcomingMoviesFirstLoad() throws {
        listMoviesViewModel.fetchMovies(.upcoming, isFirstLoad: true)
        guard let isError = listMoviesViewModel.isError.value
        else {
            return
        }
        if isError {
            XCTAssertEqual(listMoviesViewModel.errorMessage.value??.isEmpty, true)
        } else {
            XCTFail(listMoviesViewModel.errorMessage.value!!)
        }
    }
    
    func testFetchListTopRatedMoviesFirstLoad() throws {
        listMoviesViewModel.fetchMovies(.topRated, isFirstLoad: true)
        guard let isError = listMoviesViewModel.isError.value
        else {
            return
        }
        if isError {
            XCTAssertEqual(listMoviesViewModel.errorMessage.value??.isEmpty, true)
        } else {
            XCTFail(listMoviesViewModel.errorMessage.value!!)
        }
    }
    
    func testFetchListNowPlayingMoviesFirstLoad() throws {
        listMoviesViewModel.fetchMovies(.nowPlaying, isFirstLoad: true)
        guard let isError = listMoviesViewModel.isError.value
        else {
            return
        }
        if isError {
            XCTAssertEqual(listMoviesViewModel.errorMessage.value??.isEmpty, true)
        } else {
            XCTFail(listMoviesViewModel.errorMessage.value!!)
        }
    }
    
    // MARK:- Detail movie tests
    
    func testDetailMovieObject() throws {
        if let id = detailMovieViewModel.detailMoviesModel.value?.id {
            XCTAssertNotNil(id, "Detail movie data found")
        }
    }
    
    func testMovieHasReviews() throws {
        if let reviews = detailMovieViewModel.reviewsModel.value {
            XCTAssertNotEqual(reviews.count, 0)
        }
    }
    
    
    // MARK:- Favorite Movies
    
    func testUserAddMovieToFavorite_ReadSavedFavoriteMovie() throws {
        guard let json = Bundle(for: type(of: self)).path(forResource: "DetailMovie", ofType: "json")
        else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: json), options: .mappedIfSafe)
            let decode = try JSONDecoder().decode(DetailMovieModel.self, from: data)
            favoriteViewModel.getFavoriteMovies()
            let filterExistingData = favoriteViewModel.favoriteMovies.value?.filter {
                $0.id == decode.id
            }
            
            if filterExistingData?.count != 1 {
                FavoriteMoviesProcess.insert(decode)
                if let moviesCount = favoriteViewModel.favoriteMovies.value?.count {
                    XCTAssertGreaterThan(moviesCount, 0)
                }
            } else {
                XCTFail("Movie already favorited, please run testUserDeleteMovieFromFavoriteMovies function to avoid redundancy data")
            }
        }
    }
    
    func testUserDeleteMovieFromFavoriteMovies() throws {
        guard let json = Bundle(for: type(of: self)).path(forResource: "DetailMovie", ofType: "json")
        else {
            return
        }
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: json), options: .mappedIfSafe)
            let decode = try JSONDecoder().decode(DetailMovieModel.self, from: data)
            favoriteViewModel.deleteMovies(decode.id)
            let filterLocalData = favoriteViewModel.favoriteMovies.value?.filter { $0.id == decode.id }
            XCTAssertTrue(filterLocalData?.count == 0)
        } catch {
            print(error)
        }
    }
}
