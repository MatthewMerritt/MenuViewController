//
//  MenuViewController.swift
//  Utilities
//
//  Created by Matthew Merritt on 11/13/19.
//  Copyright © 2019 Matthew Merritt. All rights reserved.
//

import UIKit

// on iphone calling with modalPresentationStyle = .popover creates a popover
//                                               = .pageSheet, .formSheet .automatic create a card
//                                               = .fullScreen, .overFullScreen, .currentContext, .overCurrentContext covers complete screen
// on iPad                                       = .popover creates a popover
//                                               = .automatic, .pageSheet create a large centered view
//                                               = .formSheet create a small centered view
//                                               = .fullScreen, .overFullScreen, .currentContext, .overCurrentContext covers complete screen

public class MenuViewController: UIViewController {

    //
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.5
    public var animationDuration: TimeInterval = 0.5
    public var whatTheFuckNumberIsThis: CGFloat {
        get {
            return -wrappedNavigationController.navigationBar.frame.height
        }
    }

    private var startLocationY: CGFloat = 0

    private enum PanDirection {
        case up
        case down
    }

    //
    private var wrappedNavigationController: UINavigationController!
    private var scrollView: UIScrollView?

    public var shouldHideNavigationBar = false {
        didSet {
            self.wrappedNavigationController.setNavigationBarHidden(self.shouldHideNavigationBar, animated: true)
        }
    }

    private var hasDoneButton = false

    /// Init with all settings
    public init(rootViewController: UIViewController,
                shouldHideNavigationBar: Bool = false,
                modalPresentationStyle: UIModalPresentationStyle = .custom,
                preferredContentSize: CGSize = CGSize(width: 0, height: 200),
                barButtonItem: UIBarButtonItem? = nil,
                sourceView: UIView? = nil,
                sourceRect: CGRect? = nil,
                hasDoneButton: Bool = false) {

        super.init(nibName: nil, bundle: nil)

        wrappedNavigationController = UINavigationController(rootViewController: rootViewController)
        wrappedNavigationController.delegate = self

        self.shouldHideNavigationBar = shouldHideNavigationBar
        self.modalPresentationStyle = modalPresentationStyle
        self.preferredContentSize = preferredContentSize

        if shouldHideNavigationBar == false {
            self.preferredContentSize.height += self.wrappedNavigationController.navigationBar.frame.height + 20
        }

        if let sourceView = sourceView, let sourceRect = sourceRect {
            self.popoverPresentationController?.sourceView = sourceView
            self.popoverPresentationController?.sourceRect = sourceRect
        } else if let barButtonItem = barButtonItem {
            self.popoverPresentationController?.barButtonItem = barButtonItem
        } else {
            fatalError("Must have either sourceView & sourceRect or barButtonItem.")
        }

        self.hasDoneButton = hasDoneButton

        if hasDoneButton, let navigationItem = wrappedNavigationController.viewControllers.first?.navigationItem {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hide))
            navigationItem.leftBarButtonItem = doneButton
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        wrappedNavigationController.willMove(toParent: self)
        addChild(wrappedNavigationController)
        view.addSubview(wrappedNavigationController.view)

        // We only allow gestured closing on .custom
        if modalPresentationStyle == .custom {
            // Listen for pan gesture
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            panGesture.delegate = self
            view.addGestureRecognizer(panGesture)
        }

        view.layer.cornerRadius = 15
        view.clipsToBounds = true

    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        wrappedNavigationController.isNavigationBarHidden = shouldHideNavigationBar
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // We only allow gestured closing on .custom
        if modalPresentationStyle == .custom {
            scrollView = findScrollView(from: self.view) as? UIScrollView
            scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
            scrollView?.panGestureRecognizer.addTarget(self, action: #selector(handleScrollPan(_:)))
        }

    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            if let scroll = scrollView, scroll.contentOffset.y < whatTheFuckNumberIsThis {
                scrollView?.setContentOffset(CGPoint(x: 0, y: whatTheFuckNumberIsThis), animated: false)
            }
        }
    }

    func findScrollView(from view: UIView) -> UIView? {
        return view.firstSubView(ofType: UIScrollView.self)
    }

    @objc private func hide() {
        dismiss(animated: true, completion: nil)
    }

    public func present(_ viewController: UIViewController? = nil) {
        // Set delegates
        presentationController?.delegate = self
        transitioningDelegate = self

        // If we are not attached to a UIViewController then present on main window
        guard viewController != nil else {
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(self, animated: true)
            return
        }

        viewController?.present(self, animated: true)
    }

}

// MARK: - UIPopoverPresentationControllerDelegate
extension MenuViewController: UIPopoverPresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}

// MARK: - UINavigationControllerDelegate Functions
extension MenuViewController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            if shouldHideNavigationBar {
                self.wrappedNavigationController.setNavigationBarHidden(false, animated: true)
            }

            return MenuViewControllerPushAnimator(type: .navigation, duration: 0.25)

        case .pop:
            if shouldHideNavigationBar {
                self.wrappedNavigationController.setNavigationBarHidden(true, animated: true)
            }

            return MenuViewControllerPopAnimator(type: .navigation, duration: 0.25)


        default:
            return nil
        }
    }

}

// MARK: - UIViewControllerTransitioningDelegate functions
extension MenuViewController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuViewControllerSizedPushAnimator(type: .navigation, duration: 0.5)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuViewControllerSizedPopAnimator(type: .navigation, duration: 0.5)
    }

}

// MARK: - UIGestureRecognizer and Delegate
extension MenuViewController: UIGestureRecognizerDelegate {

    @objc func handleScrollPan(_ recognizer: UIPanGestureRecognizer) {

        let vel = recognizer.velocity(in: self.view)

        let direction: PanDirection = vel.y <= 0 ? .up : .down

        if direction == .up && self.view.superview!.frame.origin.y == 0 {
            return
        }

        if direction == .down && scrollView!.contentOffset.y > whatTheFuckNumberIsThis {
            return
        }

        onPan(recognizer)

    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {

        func slideViewVertically(to y: CGFloat) {
            self.view.superview!.frame.origin = CGPoint(x: 0, y: y)
        }

        func slideViewHorizontallyTo(_ x: CGFloat) {
            self.view.superview!.frame.origin = CGPoint(x: x, y: 0)
        }

        let translation = panGesture.translation(in: view)
        let y = max(0, translation.y)

        switch panGesture.state {

        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            startLocationY = startLocationY == 0 ? -translation.y : startLocationY
            slideViewVertically(to: startLocationY + y)

        case .ended:

            // If pan ended, decide if we should close or reset the view
            // based on the final position and the speed of the gesture
            startLocationY = 0
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
                          (velocity.y > minimumVelocityToHide)

            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    slideViewVertically(to: self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    slideViewVertically(to: 0)
                })
            }

        default:
            // If gesture state is undefined, reset the view to the top
            startLocationY = 0

            UIView.animate(withDuration: animationDuration, animations: {
                slideViewVertically(to: 0)
            })

        }

    }

}
