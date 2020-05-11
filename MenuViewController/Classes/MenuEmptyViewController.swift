//
//  MenuEmptyViewController.swift
//  MenuViewController
//
//  Created by Matthew Merritt on 5/11/20.
//

import UIKit

open class MenuEmptyViewController: UIViewController {

    open override var preferredContentSize: CGSize {
        get {
            super.preferredContentSize
        }
        set {
            super.preferredContentSize = newValue

            parent?.preferredContentSize = newValue
            parent?.parent?.preferredContentSize = newValue
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        parent?.preferredContentSize = preferredContentSize
        parent?.parent?.preferredContentSize = preferredContentSize

        super.viewWillAppear(animated)
    }
}

