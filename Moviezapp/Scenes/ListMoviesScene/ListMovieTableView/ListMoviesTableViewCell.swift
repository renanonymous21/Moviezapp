//
//  ListMoviesTableViewCell.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import UIKit

class ListMoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: CustomImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieReleaseDate: UILabel!
    @IBOutlet private weak var movieDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        moviePoster.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 240 / 255, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moviePoster.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ model: MovieModel) {
        guard let posterPath = model.posterPath,
              let releaseDate = model.releaseDate
        else {
            return
        }
        movieTitle.text = model.title
        movieReleaseDate.text = "Release on " + formatDateBasic(releaseDate)
        movieDescription.text = model.overview
        
        if posterPath.isEmpty {
            moviePoster.image = UIImage(named: "image_default_poster")
        } else {
            let posterUrl = ServerEnvironments.shared.imageBaseUrl + posterPath
            moviePoster.loadImage(urlString: posterUrl, id: UUID())
        }
    }
}
