//
//  SystemPopAnimator.swift
//  CustomTransition
//
//  Created by Tibor Bödecs on 2018. 04. 26..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

open class MenuViewControllerPopAnimator: MenuViewControllerAnimator {

    let interactionController: UIPercentDrivenInteractiveTransition?

    public init(type: TransitionType, duration: TimeInterval = 0.25, interactionController: UIPercentDrivenInteractiveTransition? = nil) {

        self.interactionController = interactionController
        super.init(type: type, duration: duration)
    }

    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {

            let fromView = fromVC.view
            let toView = toVC.view
            let containerView = transitionContext.containerView

            containerView.clipsToBounds = false
            containerView.addSubview(toView!)

            var fromViewEndFrame = fromView?.frame
            fromViewEndFrame?.origin.x += (containerView.frame.width)

            let toViewEndFrame = transitionContext.finalFrame(for: toVC)
            var toViewStartFrame = toViewEndFrame
            toViewStartFrame.origin.x -= (containerView.frame.width)
            toView?.frame = toViewStartFrame

            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                toView?.frame = toViewEndFrame
                fromView?.frame = fromViewEndFrame!
            }, completion: { (completed) -> Void in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(completed)
                containerView.clipsToBounds = true
            })
        }

    }
}

