//
//  SinaLikePopupView.swift
//  CAtFE
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
    var petList: [String] = ["貓", "狗", "其他", "全部"]
    var iconList: [String] = ["cat", "bulldog", "chameleon", "cafe"]
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let animation = Animation()
    
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
}

extension SinaLikePopupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopupCollectionViewCell.identifier,
                                                            for: indexPath) as? PopupCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(title: petList[indexPath.item], icon: iconList[indexPath.row])
        return cell
    }
}

extension SinaLikePopupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: false)
        selectedPet?(petList[indexPath.item])
        animation.setFallAnimate(viewController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        animation.setCollectionViewSpringAnimate(cell: cell, indexPath: indexPath)
        self.closeBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        self.collectionView.layoutIfNeeded()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
        return CGSize(width: width * 0.3, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
