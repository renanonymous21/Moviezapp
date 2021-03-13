//
//  CustomImageView.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import UIKit

public var imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    let activityIndicator = UIActivityIndicatorView()
    var imageId: UUID?
    
    override var intrinsicContentSize: CGSize {
        if let img = self.image {
            let ratio = self.frame.size.width / img.size.width
            let newHeight = img.size.height * ratio

            return CGSize(width: self.frame.size.width, height: newHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }
    
    func loadImage(urlString: String, id: UUID) {
        self.image = nil
        imageId = id
        activityIndicator.color = .black
        activityIndicator.style = .gray
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: id as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        
        if let url = URL(string: urlString) {
            downloadImage(url: url, id: id)
        }
    }

    func downloadImage(url: URL, id: UUID) {
        ImageDownloader.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                if let img = UIImage(data: data) {
                    if self.imageId == id {
                        self.image = img
                    }
                    imageCache.setObject(img, forKey: id as AnyObject)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
