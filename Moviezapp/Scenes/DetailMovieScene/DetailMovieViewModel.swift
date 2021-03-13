//
//  DetailMovieViewModel.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import Foundation

protocol DetailMovieBusinessLogic {
    func getDetailMovie(movieId: Int)
    func getMovieReviews(movieId: Int, firstLoad: Bool)
}

final class DetailMovieViewModel: NSObject, DetailMovieBusinessLogic {
    
    var detailMoviesModel = Observable<DetailMovieModel>()
    var reviewsModel = Observable<[ReviewsModel]>()
    var isFavorited = Observable<Bool>()
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "movieDetailQueue")
    private var page = 1
    var totalReviewPage = Observable<Int>()
    
    init(movieId: Int) {
        super.init()
        self.executeOnInit(movieId: movieId)
    }
    
    private func executeOnInit(movieId: Int) {
        totalReviewPage.value = 1
        getDetailMovie(movieId: movieId)
        getMovieReviews(movieId: movieId, firstLoad: true)
        isFavorited.value = false
        group.notify(queue: .main) {
            print("done fetching")
        }
    }
    
    func getDetailMovie(movieId: Int) {
        group.enter()
        APIManager.request(MoviesUseCases.getMovieDetail(movieId: movieId)) { [weak self] (result: Result<DetailMovieModel, RuntimeError>) in
            do {
                let response = try result.get()
                self?.detailMoviesModel.value = response
            } catch {
                print(error)
            }
            self?.group.leave()
        }
    }
    
    func getMovieReviews(movieId: Int, firstLoad: Bool) {
        group.enter()
        
        switch firstLoad {
        case true:
            page = 1
        case false:
            if (totalReviewPage.value ?? 1) > 1 {
                page += 1
            }
        }
        
        APIManager.request(MoviesUseCases.getMovieReviews(movieId: movieId, page: page)) { [weak self] (result: Result<ReviewsResponseModel, RuntimeError>) in
            do {
                let response = try result.get()
                self?.totalReviewPage.value = response.totalPages
                if let currentPage = self?.page {
                    if currentPage > 1 {
                        self?.reviewsModel.value? += response.results
                    } else {
                        self?.reviewsModel.value = response.results
                    }
                }
            } catch {
                print(error)
            }
            self?.group.leave()
        }
    }
}
