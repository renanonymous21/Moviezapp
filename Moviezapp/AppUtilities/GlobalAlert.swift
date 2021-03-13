//
//  GlobalAlert.swift
//  Moviezapp
//
//  Created by Rendy K. R on 13/03/21.
//

import UIKit

public class GlobalAlert {
    static func info(title: String, message: String) -> Void {
        let viewController = UIApplication.topViewController()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(ok)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
