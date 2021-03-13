//
//  DetailMovieTableViewController.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import UIKit

class DetailMovieTableViewController: UITableViewController {

    var movieId: Int?
    private var viewModel: DetailMovieViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    enum SectionName: String {
        case info = "Movie Information"
        case reviews = "User Reviews"
        
        var value: String {
            return self.rawValue
        }
    }
    
    private func updateUI() {
        self.title = "Movie Detail"
        if let id = movieId {
            viewModel = DetailMovieViewModel(movieId: id)
        }
        
        viewModel?.detailMoviesModel.bind { _ in
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        
        viewModel?.reviewsModel.bind { _ in
            self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if viewModel?.reviewsModel.value?.count == 0 {
                let emptyLabel = UILabel()
                emptyLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
                emptyLabel.numberOfLines = 0
                emptyLabel.text = "Sorry, no reviews for this movie"
                emptyLabel.textAlignment = .center
                tableView.backgroundView = emptyLabel
                tableView.separatorStyle = .none
                
                return 0
            }
            return viewModel?.reviewsModel.value?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return SectionName.info.value
        case 1:
            return SectionName.reviews.value
        default:
            return "unknown"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieInformationCell", for: indexPath) as? MovieInformationTableViewCell
            else {
                return UITableViewCell()
            }
            if let movie = viewModel?.detailMoviesModel.value {
                cell.cofigure(movie)
            }
           
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieReviewsCell", for: indexPath) as? MovieReviewsTableViewCell
            else {
                return UITableViewCell()
            }
            
            if let model = viewModel?.reviewsModel.value?[indexPath.row] {
                cell.configure(model)
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellCount = viewModel?.reviewsModel.value?.count,
           let movieId = movieId,
           let totalReviewPage = viewModel?.totalReviewPage.value {
            let last  = cellCount - 1
            if totalReviewPage > 1 && indexPath.row == last {
                viewModel?.getMovieReviews(movieId: movieId, firstLoad: false)
            }
        }
    }
    
    private func isFavoritedAlert() {
        let alert = UIAlertController(title: "Info", message: "This movie already added to your favorite list", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
