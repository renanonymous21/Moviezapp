//
//  UIApplication+TopViewController.swift
//  Moviezapp
//
//  Created by Rendy K. R on 13/03/21.
//

import UIKit

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let navController = base as? UINavigationController {
            return topViewController(base: navController.visibleViewController)

        } else if let tabBarController = base as? UITabBarController, let selected = tabBarController.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
