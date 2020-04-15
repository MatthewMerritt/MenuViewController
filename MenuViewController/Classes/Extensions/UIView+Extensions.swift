//
//  FindView.swift
//  Utilities
//
//  Created by Matthew Merritt on 12/7/19.
//

import UIKit

// MARK: - Extension to recursively find a view in subviews
//
// https://stackoverflow.com/users/7285819/shtnkgm

/// UIView Extension
public extension UIView {

    /// Find an array of UIViews that are of certain Class
    func findViews<T: UIView>(ofClass: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    /// Find all subviews of a UIView
    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }

    /// Find first subView of type
    func firstSubView<T: UIView>(ofType type: T.Type) -> T? {
        var resultView: T?

        for view in subviews {
            if let view = view as? T {
                resultView = view
                break
            } else {
                if let foundView = view.firstSubView(ofType: T.self) {
                    resultView = foundView
                    break
                }
            }
        }

        return resultView
    }

}


