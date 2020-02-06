//
//  SinaLikePopupView.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol SinaLikePopupViewDelegate: AnyObject {
    func collectionView(collectionView: UICollectionView, with animationTime: TimeInterval) // TODO: set animation
}

class SinaLikePopupViewController: UIViewController {

    weak var delegate: SinaLikePopupViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var popupView = UIView()
    var animateDuration: TimeInterval = 0.25
    var overlayAlpha: CGFloat = 0.5

    let width = UIScreen.main.bounds.width
}

extension SinaLikePopupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopupCollectionViewCell.identifier, for: indexPath) as? PopupCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension SinaLikePopupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        flowLayout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        return CGSize(width: (width - 32) / 3, height: 100)
    }
}
