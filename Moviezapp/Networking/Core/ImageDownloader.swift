//
//  ImageDownloader.swift
//  Moviezapp
//
//  Created by Rendy K. R on 10/03/21.
//

import Foundation

class ImageDownloader {
    
    class func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    class func cancelFetch() {
        URLSession.shared.invalidateAndCancel()
    }
}
