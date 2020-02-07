//
//  SinaLikePopupView.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class SinaLikePopupViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    var selectedPet: ((String) -> Void)?
    var petList: [String] = ["貓", "狗", "其他"]
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @IBAction func closePopupView(_ sender: Any) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
            self.closeBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
            self.collectionViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func initView() {
        self.view.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 10
    }
    
    // - Animation support -
    
    func setSpringAnimate(cell: UICollectionViewCell, indexPath: IndexPath) {
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        let animator = UIViewPropertyAnimator(duration: 1, timingParameters: spring)
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: height * 0.2)
        animator.addAnimations {
            cell.alpha = 1
            cell.transform = .identity
            self.closeBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.collectionView.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.2 * Double(indexPath.item))
    }
    
    func setFallAnimate() { // TODO: 做掉下去的動畫
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0.2,
            options: .curveEaseOut,
            animations: {
                self.collectionView.alpha = 0
        },
            completion: { _ in
                self.dismiss(animated: false, completion: nil)
        })
    }
}

extension SinaLikePopupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopupCollectionViewCell.identifier, for: indexPath) as? PopupCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.iconLabel.text = petList[indexPath.item]
        return cell
    }
}

extension SinaLikePopupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: false)
        selectedPet?(petList[indexPath.item])
        setFallAnimate()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setSpringAnimate(cell: cell, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        flowLayout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        return CGSize(width: width * 0.3, height: 120)
    }
}
