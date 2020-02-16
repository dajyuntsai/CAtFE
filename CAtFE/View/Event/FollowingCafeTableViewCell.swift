//
//  FollowingCafeTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol GoodCommentShareDelegate: AnyObject {
    func getCommentView(_ cell: FollowingCafeTableViewCell)
    func getShareView(_ cell: FollowingCafeTableViewCell)
    func getEditView(_ cell: FollowingCafeTableViewCell)
}

class FollowingCafeTableViewCell: UITableViewCell {

    weak var delegate: GoodCommentShareDelegate?
    var goodBtnState = false
    var timer = Timer()
    var imageIndex = 0
    let photoList = ["banner1", "banner2", "banner1"]
    let width = UIScreen.main.bounds.size.width
    
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBAction func goodBtnClick(_ sender: Any) {
        goodBtnState = !goodBtnState
        let btnImg = goodBtnState == true ?
            UIImage(named: "select_like") : UIImage(named: "unselect_like")
        goodBtn.setImage(btnImg, for: .normal)
    }
    
    @IBAction func commentBtnClick(_ sender: Any) {
        delegate?.getCommentView(self)
    }
    
    @IBAction func shareBtnClick(_ sender: Any) {
        delegate?.getShareView(self)
    }
    
    @IBAction func moreBtnClick(_ sender: Any) {
        delegate?.getEditView(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
        addTimer()
    }
    
    func initView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        if photoList.count == 0 {
            heightOfCollectionView.constant = 0
        } else {
            heightOfCollectionView.constant = 150
        }
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = photoList.count - 1
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(named: "MainColor")
        pageControl.hidesForSinglePage = true
    }
    
    func addTimer() {
        let timerLoop = Timer.scheduledTimer(timeInterval: 2,
                                             target: self,
                                             selector: #selector(nextPageView),
                                             userInfo: nil,
                                             repeats: true)
        RunLoop.current.add(timerLoop, forMode: RunLoop.Mode.common)
        timer = timerLoop
    }
    
    @objc func nextPageView() {
        var indexPath: IndexPath
        imageIndex += 1
        if imageIndex < photoList.count {
            indexPath = IndexPath(item: imageIndex, section: 0)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            imageIndex = 0
            indexPath = IndexPath(item: imageIndex, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            nextPageView()
        }
        self.pageControl.currentPage = imageIndex
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FollowingCafeTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoList.count == 0 {
            return 0
        } else {
            return photoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventPhotoCollectionViewCell.identifier,
                                                            for: indexPath) as? EventPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.eventPhotoImageView.image = UIImage(named: photoList[indexPath.row])
        return cell
    }
}

extension FollowingCafeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if photoList.count == 0 {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 150)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / (Int(width) % (photoList.count - 1))
    }
}
