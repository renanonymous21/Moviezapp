//
//  MovieInformationTableViewCell.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import UIKit

class MovieInformationTableViewCell: UITableViewCell {
    @IBOutlet private weak var moviePoster: CustomImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieReleaseDate: UILabel!
    @IBOutlet private weak var movieOverview: UILabel!
    @IBOutlet private weak var movieStatus: UILabel!
    @IBOutlet private weak var movieRating: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    private var modelToSave: DetailMovieModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        moviePoster.image = UIImage(named: "image_default_poster")
        movieTitle.text = "loading..."
        movieReleaseDate.text = "loading..."
        movieOverview.text = "loading..."
        movieStatus.text = "loading..."
        movieRating.text = "-"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cofigure(_ movie: DetailMovieModel) {
        modelToSave = movie
        movieTitle.text = movie.title
        movieReleaseDate.text = "Release on " + formatDateBasic(movie.releaseDate)
        movieOverview.text = movie.overview
        movieStatus.text = movie.status
        movieRating.text = "⭐️ \(movie.rating)"
        favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        if movie.posterPath.isEmpty {
            moviePoster.image = UIImage(named: "image_default_poster")
        } else {
            let posterUrl = ServerEnvironments.shared.imageBaseUrl + movie.posterPath
            moviePoster.loadImage(urlString: posterUrl, id: UUID())
        }
        if isFavoritedMovie() {
            favoriteButton.setImage(UIImage(named: "icon_like_fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "icon_like_outline"), for: .normal)
        }
        
    }
    
    private func isFavoritedMovie() -> Bool {
        do {
            let localFavorites = try FavoriteMoviesProcess.read()
            let filteredData = localFavorites.filter { $0.id == modelToSave?.id }
            
            if filteredData.count == 1 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    @objc
    private func addToFavorite() {
        let favMovie = isFavoritedMovie()
        if favMovie {
            GlobalAlert.info(title: "Info", message: "This movie already added to your favorite list")
        } else {
            if let model = modelToSave {
                FavoriteMoviesProcess.insert(model)
                favoriteButton.setImage(UIImage(named: "icon_like_fill"), for: .normal)
            }
        }
    }
}
