//
//  SizedPopAnimator.swift
//  Utilities
//
//  Created by Matthew Merritt on 12/21/19.
//

import UIKit

open class MenuViewControllerSizedPopAnimator: MenuViewControllerAnimator {

    override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!

        UIView.animate(withDuration: 0.2, animations: {
            fromView.frame.origin.y += container.frame.height - fromView.frame.minY
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
        
    }

}
