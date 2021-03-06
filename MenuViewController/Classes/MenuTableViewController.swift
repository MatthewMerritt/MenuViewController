//
//  PopoverMenuViewController.swift
//  Exercise
//
//  Created by Matthew Merritt on 3/20/20.
//  Copyright © 2020 Matthew Merritt. All rights reserved.
//

import UIKit


// MARK: - AddMenuDelegate Protocol
public protocol MenuTableViewControllerDelegate {
    func didSelectMenu(menuTableViewController: MenuTableViewController, row: Int, menuItem: MenuItem)
}

// MARK: - MenuItem
public struct MenuItem {
    var image: UIImage
    var title: String

    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}

// MARK: - MenuTableViewController
open class MenuTableViewController: UITableViewController {

    // MARK: Public Properties
    public var delegate: MenuTableViewControllerDelegate?

    public typealias DidSelectMenu = (MenuTableViewController, Int, MenuItem) -> Void
    public var didSelectMenu: DidSelectMenu? = nil

    public var dismissOnSelection: Bool = true

    public var hasNavigationController: Bool = false

    public var menuItems: [MenuItem] = [] {
        didSet {

            self.preferredContentSize.height = CGFloat(self.menuItems.count) * self.tableView.rowHeight + (self.hasNavigationController ? 44 : 0)
            self.parent?.parent?.preferredContentSize.height = CGFloat(self.menuItems.count) * self.tableView.rowHeight + (self.hasNavigationController ? 44 : 0)

            self.preferredContentSize.width = self.menuItems.map { $0.title.size(withAttributes: [.font : UIFont.preferredFont(forTextStyle: .body)]).width }.max()! + 57
            self.parent?.parent?.preferredContentSize.width = self.menuItems.map { $0.title.size(withAttributes: [.font : UIFont.preferredFont(forTextStyle: .body)]).width }.max()! + 57

            self.tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect1 = UIBlurEffect(style: .light)
        let blurredEffectView1 = UIVisualEffectView(effect: blurEffect1)
        blurredEffectView1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredEffectView1.frame = view.bounds

        tableView.backgroundColor = .clear
        tableView.backgroundView = blurredEffectView1
        tableView.separatorInset = .zero

        tableView.rowHeight = 40
        tableView.contentInset.top = 15
        tableView.isScrollEnabled = false

        if hasNavigationController {
            tableView.contentInset.top += 30
        }

    }

    public override func viewWillAppear(_ animated: Bool) {
        self.menuItems = { self.menuItems }()
        super.viewWillAppear(animated)

        //        if popoverPresentationController?.arrowDirection == .down {
        //        if navigationController?.isNavigationBarHidden == false {
        //                tableView.contentInset.top = 45
        //        } else {
        tableView.contentInset.top = 0
        //        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        cell.indentationLevel = 4

        let menuItem = menuItems[indexPath.row]

        if let imageView = cell.viewWithTag(666) as? UIImageView {
            imageView.image = menuItem.image
        } else {
            let newImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
            newImageView.translatesAutoresizingMaskIntoConstraints = false
            newImageView.image = menuItem.image
            newImageView.tag = 666

            cell.addSubview(newImageView)
            newImageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 8).isActive = true
            newImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
            newImageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
            newImageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
        }

        cell.textLabel?.text = menuItem.title
        cell.backgroundColor = .clear

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectMenu(menuTableViewController: self, row: indexPath.row, menuItem: menuItems[indexPath.row])

        didSelectMenu?(self, indexPath.row, menuItems[indexPath.row])

        if dismissOnSelection {
            dismiss(animated: true) { }
        }
    }
}
