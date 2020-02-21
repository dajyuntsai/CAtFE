//
//  Animation.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/21.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class Animation {
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    func setTableViewSpringAnimate(cell: UITableViewCell, indexPath: IndexPath) {
        let spring = UISpringTimingParameters(dampingRatio: 0.6, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        let animator = UIViewPropertyAnimator(duration: 1, timingParameters: spring)
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: height * 0.2)
        animator.addAnimations {
            cell.alpha = 1
            cell.transform = .identity
            self.tableView?.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.08 * Double(indexPath.item))
    }
    
    func setCollectionViewSpringAnimate(cell: UICollectionViewCell, indexPath: IndexPath) {
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        let animator = UIViewPropertyAnimator(duration: 1, timingParameters: spring)
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: height * 0.2)
        animator.addAnimations {
            cell.alpha = 1
            cell.transform = .identity
            self.collectionView?.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
    
    func setFallAnimate(viewController: UIViewController) { // TODO: 做掉下去的動畫
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0.2,
            options: .curveEaseOut,
            animations: {
                self.collectionView?.alpha = 0
        },
            completion: { _ in
                viewController.dismiss(animated: false, completion: nil)
        })
    }
}
