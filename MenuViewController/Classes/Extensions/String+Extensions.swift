//
//  String+Extensions.swift
//  MenuViewController
//
//  Created by Matthew Merritt on 4/16/20.
//

import Foundation

extension String {

    /// Get the size of a string with a given font.
    /// - Parameter font: font
    /// - Returns: the CGSize of the give string
    func size(with font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }

}
