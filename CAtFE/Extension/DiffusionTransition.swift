//
//  DiffusionTransition.swift
//  CAtFE
//
//  Created by Ninn on 2020/3/5.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

enum PresentMode {
    case present, dismiss
}

class DiffusionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var selectedView: UIView = UIView()
    var startingPoint = CGPoint.zero
    var circleColor: UIColor?
    var duration = 0.8
    var transitionMode: PresentMode = .present
    
    // animation time
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // animation script
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // container view
        let containerView = transitionContext.containerView
        if transitionMode == .present {
            // to view
            toViewAnimation(containerView: containerView, transitionContext: transitionContext)
        } else {
            // from View
            toViewAnimation(transitionContext: transitionContext)
        }
    }
    
    func toViewAnimation(containerView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        let viewCenter = toVC.view.center
        let viewSize = toVC.view.frame.size
        selectedView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
        selectedView.layer.cornerRadius = selectedView.frame.size.width / 2
        selectedView.center = startingPoint
        selectedView.backgroundColor = circleColor
        selectedView.alpha = 1
        selectedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        containerView.addSubview(selectedView)
        
        toVC.view.center = startingPoint
        toVC.view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.selectedView.transform = CGAffineTransform.identity
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.alpha = 1
            toVC.view.center = viewCenter
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    func toViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let returningVC = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        let viewCenter = returningVC.view.center
        self.selectedView.transform = CGAffineTransform.identity
        returningVC.view.alpha = 1
        selectedView.alpha = 1
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.selectedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            returningVC.view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            returningVC.view.alpha = 0
            returningVC.view.center = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        }) { (_) in
            returningVC.view.center = viewCenter
            returningVC.view.removeFromSuperview()
            self.selectedView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    func frameForCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
