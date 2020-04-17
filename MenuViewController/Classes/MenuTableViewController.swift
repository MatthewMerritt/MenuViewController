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
    func didSelectMenu(popoverMenuViewController: MenuTableViewController ,row: Int)
}

// MARK: - MenuTableViewController
public class MenuTableViewController: UITableViewController {

    public var delegate: MenuTableViewControllerDelegate?

    public var dismissOnSelection: Bool = true

    public var hasNavigationController: Bool = false

    public var menuItems: [(image: UIImage, title: String)] = [] {
        didSet {
            super.preferredContentSize.height = CGFloat(self.menuItems.count) * self.tableView.rowHeight

            super.preferredContentSize.width = self.menuItems.map { $0.title.size(with: UIFont.preferredFont(forTextStyle: .body)).width }.max()! + 56

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
        super.viewWillAppear(animated)

        if popoverPresentationController?.arrowDirection == .down {
            tableView.contentInset.top = 0
        }
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
        delegate?.didSelectMenu(popoverMenuViewController: self, row: indexPath.row)

        if dismissOnSelection {
            dismiss(animated: true) { }
        }
    }
}
