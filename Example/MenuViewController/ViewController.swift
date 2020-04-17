//
//  ViewController.swift
//  MenuViewController
//
//  Created by MatthewMerritt on 04/14/2020.
//  Copyright (c) 2020 MatthewMerritt. All rights reserved.
//

import UIKit
import MenuViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: MenuTableViewControllerDelegate {

    @IBAction func infoButtonTapped(_ sender: UIBarButtonItem) {

        var pushController: MenuViewController!

        let addRepMenuPopoverViewController = MenuTableViewController()

        addRepMenuPopoverViewController.preferredContentSize = CGSize(width: 200, height: 90)
        addRepMenuPopoverViewController.modalPresentationStyle = .custom
        addRepMenuPopoverViewController.delegate = self
        addRepMenuPopoverViewController.dismissOnSelection = false
        addRepMenuPopoverViewController.hasNavigationController = true

        addRepMenuPopoverViewController.menuItems = [
            (image: UIImage(named: "Circle")!, title: "\(Bundle.main.displayName) \(Bundle.main.versionString)"),
            (image: UIImage(named: "Square")!, title: "AutoCompleteAccessoryView"),
            (image: UIImage(named: "Triangle")!, title: "EasyClosure"),
            (image: UIImage(named: "Square")!, title: "EMTNeumorphicView"),
            (image: UIImage(named: "Circle")!, title: "PDFForm"),
        ]

        pushController = MenuViewController(rootViewController: addRepMenuPopoverViewController, modalPresentationStyle: .popover, preferredContentSize: addRepMenuPopoverViewController.preferredContentSize, barButtonItem: sender, sourceView: self.view, sourceRect: CGRect(x: 0, y: 0, width: 20, height: 20), hasDoneButton: true)

        pushController.shouldHideNavigationBar = true

        pushController.present()

        //        present(addRepMenuPopoverViewController, animated: true, completion: nil)

    }

    func didSelectMenu(popoverMenuViewController: MenuTableViewController, row: Int) {

//        popoverMenuViewController.navigationController?.pushViewController(UIViewController(), animated: true)
        popoverMenuViewController.tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: false)

    }

}
