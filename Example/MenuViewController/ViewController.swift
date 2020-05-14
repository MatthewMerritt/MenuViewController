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

    var pushController: MenuViewController!

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

        let addRepMenuPopoverViewController = MenuTableViewController()

        addRepMenuPopoverViewController.preferredContentSize = CGSize(width: 200, height: 90)
        addRepMenuPopoverViewController.modalPresentationStyle = .custom
        addRepMenuPopoverViewController.delegate = self
        addRepMenuPopoverViewController.dismissOnSelection = false
        addRepMenuPopoverViewController.hasNavigationController = false

        addRepMenuPopoverViewController.menuItems = [
            (image: UIImage(named: "Circle")!, title: "\(Bundle.main.displayName) \(Bundle.main.versionString)"),
            (image: UIImage(named: "Square")!, title: "AutoCompleteAccessoryView"),
            (image: UIImage(named: "Triangle")!, title: "EasyClosure"),
            (image: UIImage(named: "Square")!, title: "EMTNeumorphicView"),
            (image: UIImage(named: "Circle")!, title: "PDFForm"),
        ]

        pushController = MenuViewController(rootViewController: addRepMenuPopoverViewController, modalPresentationStyle: .popover, preferredContentSize: addRepMenuPopoverViewController.preferredContentSize, barButtonItem: sender, hasDoneButton: false)

        pushController.shouldHideNavigationBar = true
        pushController.preferredContentSize = addRepMenuPopoverViewController.preferredContentSize

        pushController.present()

        //        present(addRepMenuPopoverViewController, animated: true, completion: nil)

    }

    @IBAction func actionButtonAction(_ sender: UIBarButtonItem) {
        let addRepMenuPopoverViewController = MenuTableViewController()
        addRepMenuPopoverViewController.preferredContentSize = CGSize(width: 200, height: 10)

        addRepMenuPopoverViewController.delegate = self
        addRepMenuPopoverViewController.dismissOnSelection = false
        addRepMenuPopoverViewController.hasNavigationController = false

        addRepMenuPopoverViewController.menuItems = [
            (image: UIImage(named: "Circle")!, title: "\(Bundle.main.displayName) \(Bundle.main.versionString)"),
            (image: UIImage(named: "Square")!, title: "AutoCompleteAccessoryView"),
            (image: UIImage(named: "Triangle")!, title: "EasyClosure"),
            (image: UIImage(named: "Square")!, title: "EMTNeumorphicView"),
            (image: UIImage(named: "Circle")!, title: "PDFForm"),
        ]

        addRepMenuPopoverViewController.didSelectMenu = { menu, menuItem in
            print(#function, menu, menuItem)
        }

        pushController = MenuViewController(rootViewController: addRepMenuPopoverViewController, modalPresentationStyle: .custom, preferredContentSize: addRepMenuPopoverViewController.preferredContentSize, barButtonItem: sender, hasDoneButton: true)


        pushController.shouldHideNavigationBar = false

        pushController.present()

    }

    func didSelectMenu(popoverMenuViewController: MenuTableViewController, row: Int) {

        if row == 0 {
            let vc = MenuEmptyViewController()
            vc.preferredContentSize = pushController.preferredContentSize
            vc.preferredContentSize.height += 100
            popoverMenuViewController.navigationController?.pushViewController(vc, animated: true)
        } else {
            popoverMenuViewController.tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: false)
        }

    }

}

