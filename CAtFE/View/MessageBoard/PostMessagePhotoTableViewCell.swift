//
//  PostMessagePhotoTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessagePhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoList: [UIImage] = []
    var isEditMode = false
    var editPhotoList: [Photos]?
    
    var isReload: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension PostMessagePhotoTableViewCell: UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isEditMode {
            return (editPhotoList?.count ?? 0) + 1
        } else {
            return photoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell",
                                                            for: indexPath) as? PostMessagePhotoCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        cell.delegate = self
        if isEditMode { // TODO: refactor
            guard let editPhotoList = editPhotoList else { return UICollectionViewCell() }
            if indexPath.row == editPhotoList.count {
                cell.addPhotoBtn.isHidden = false
                cell.photoImageView.isHidden = true
            } else {
                cell.addPhotoBtn.isHidden = true
                cell.photoImageView.isHidden = false
                cell.photoImageView.loadImage(editPhotoList[indexPath.item].url)
            }
        } else {
            if indexPath.row == photoList.count {
                cell.addPhotoBtn.isHidden = false
                cell.photoImageView.isHidden = true
            } else {
                cell.addPhotoBtn.isHidden = true
                cell.photoImageView.isHidden = false
                cell.photoImageView.image = photoList[indexPath.item]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}

extension PostMessagePhotoTableViewCell: DeletePhotoDelegate {
    func removePhoto(_ cell: PostMessagePhotoCollectionViewCell) {
        
    }
}
