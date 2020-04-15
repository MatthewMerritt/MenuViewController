//
//  SizedPushAnimator.swift
//  Utilities
//
//  Created by Matthew Merritt on 12/21/19.
//

import UIKit

open class MenuViewControllerSizedPushAnimator: MenuViewControllerAnimator {

    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let toViewController = transitionContext.viewController(forKey: .to)!

        // Configure the layout
        toView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(toView)

        // Specify a minimum 20pt bottom margin
//        let bottom = max(20 - toView.safeAreaInsets.bottom, 0)
        container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -toView.safeAreaInsets.bottom).isActive = true

        // Respect `toViewController.preferredContentSize.width` if non-zero
        if toViewController.preferredContentSize.width > 0 {
            toView.widthAnchor.constraint(equalToConstant: toViewController.preferredContentSize.width).isActive = true
            container.centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
        } else {
            container.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -20).isActive = true
            container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 20).isActive = true
        }

        // Respect `toViewController.preferredContentSize.height` if non-zero.
        if toViewController.preferredContentSize.height > 0 {
            toView.heightAnchor.constraint(equalToConstant: toViewController.preferredContentSize.height).isActive = true
        }

        // Apply some styling
        toView.layer.masksToBounds = true
        toView.layer.cornerRadius = 20
        toView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // Perform the animation
        container.layoutIfNeeded()
        let originalOriginY = toView.frame.origin.y
        toView.frame.origin.y += container.frame.height - toView.frame.minY
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            toView.frame.origin.y = originalOriginY
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}
