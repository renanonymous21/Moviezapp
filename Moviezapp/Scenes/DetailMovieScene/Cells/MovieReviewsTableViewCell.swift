//
//  MovieReviewsTableViewCell.swift
//  Moviezapp
//
//  Created by Rendy K. R on 11/03/21.
//

import UIKit

class MovieReviewsTableViewCell: UITableViewCell {

    @IBOutlet private weak var userAvatar: CustomImageView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var contents: UILabel!
    @IBOutlet private weak var givenRatings: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userAvatar.layer.cornerRadius = userAvatar.frame.size.height / 2
        userAvatar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(_ model: ReviewsModel) {
        username.text = "@\(model.authorDetails.username)"
        contents.text = "Reviews: \n\(model.content)"
        givenRatings.text = "⭐️ " + String(model.authorDetails.rating ?? 0.0)
        updatedAt.text = formatPosixDate(model.updatedAt)
        let avatarUrl = fixedAvatarUrl(model.authorDetails.avatarPath)
        if avatarUrl.isEmpty {
            userAvatar.image = UIImage(named: "image_default_poster")
        } else {
            userAvatar.loadImage(urlString: avatarUrl, id: UUID())
        }
    }
    
    private func fixedAvatarUrl(_ stringUrl: String) -> String {
        if !stringUrl.isEmpty || !stringUrl.contains("null") {
            let fixedUrl = firstCharacterUrlModifier(stringUrl)
            let valid = validateUrl(urlString: fixedUrl)
            if valid {
                return fixedUrl
            }
        }
        return ""
    }
    
    private func validateUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if urlString.hasPrefix("https://") {
                return true
            }
        }
        return false
    }
    
    private func firstCharacterUrlModifier(_ urlString: String) -> String {
        let firstCharacter = urlString.first?.description
        if firstCharacter != "h" {
            let validUrl = urlString.replacingCharacters(in: ...firstCharacter!.startIndex, with: "")
            return validUrl
        }
        return urlString
    }
}
