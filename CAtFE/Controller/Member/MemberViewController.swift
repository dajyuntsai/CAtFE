//
//  MemberViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pointBgView: UIView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var followingBgView: UIView!
    @IBOutlet weak var followingLabel: UILabel!
    private var mPageTitleView: TabTitleView!
    private var mPageContentView: TabContentView!
    private var scrollView = UIScrollView()

    private var titleList = ["我的留言", "按讚的留言", "追蹤的店家"]

    let conf = TabTitleConfig()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTabView()
        initBarBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userName.text = KeyChainManager.shared.name
        guard let avatar = KeyChainManager.shared.avatar else { return }
        userImageView.loadImage(avatar, placeHolder: UIImage(named: "placeholder"))
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }

    func initView() { // TODO: 往上滑的時候消失
        userViewHeight.constant = height / 5
        userName.text = KeyChainManager.shared.name
//        userImageView.loadImage(KeyChainManager.shared.avatar)
        
        pointBgView.layer.shadowOffset = CGSize(width: 2, height: 2)
        pointBgView.layer.shadowColor = UIColor.lightGray.cgColor
        pointBgView.layer.shadowOpacity = 0.5
        pointBgView.layer.shadowRadius = 2
        pointBgView.layer.cornerRadius = 15
        
        followingBgView.layer.shadowOffset = CGSize(width: 2, height: 2)
        followingBgView.layer.shadowColor = UIColor.lightGray.cgColor
        followingBgView.layer.shadowOpacity = 0.5
        followingBgView.layer.shadowRadius = 2
        followingBgView.layer.cornerRadius = 15
    }

    func initTabView() {
        let rectTitle = CGRect(x: 0, y: height / 5 + (width / 4) + 16, width: width, height: 50)
        mPageTitleView = TabTitleView(frame: rectTitle, titleArr: titleList, config: conf, delegate: self)
        self.view.addSubview(mPageTitleView)

        guard let myMessagesViewController = UIStoryboard.member
            .instantiateViewController(identifier: MyMessagesViewController.identifier)
            as? MyMessagesViewController else { return }
        guard let likeMessagesViewController = UIStoryboard.member
        .instantiateViewController(identifier: MyMessagesViewController.identifier)
        as? MyMessagesViewController else { return }
        guard let myFollowingViewController = UIStoryboard.member
            .instantiateViewController(identifier: MyFollowingViewController.identifier)
            as? MyFollowingViewController else { return }
        
        myMessagesViewController.delegate = self
        likeMessagesViewController.delegate = self
        myMessagesViewController.messageType(messagesCategory: .myMessages)
        likeMessagesViewController.messageType(messagesCategory: .likeMessages)
        myFollowingViewController.getFollowingCafe()
        
        let controllers = [myMessagesViewController,
                           likeMessagesViewController,
                           myFollowingViewController]
        let rectContent = CGRect(x: 0, y: height / 5 + (width / 4) + 16 + 50, width: width, height: height)
        mPageContentView = TabContentView(frame: rectContent, parentVC: self,
                                          childVCs: controllers,
                                          childViews: [],
                                          delegate: self)
        self.view.addSubview(mPageContentView)
    }
    
    func initBarBtn() {
        let smallImage = resizeImage(image: UIImage(named: "settings")!, width: 28)
        let settingBtn = UIButton(frame: CGRect(x: width * 0.9, y: width * 0.1, width: width * 0.07, height: width * 0.07))
        settingBtn.setImage(smallImage, for: .normal)
        settingBtn.addTarget(self, action: #selector(onUsetSetting), for: .touchUpInside)
        self.view.addSubview(settingBtn)
    }
    
    @objc func onUsetSetting() {
        let presentVC = UIStoryboard.member
            .instantiateViewController(identifier: SettingViewController.identifier)
            as? SettingViewController
        self.show(presentVC!, sender: nil)
    }
    
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
            let size = CGSize(width: width, height:
                image.size.height * width / image.size.width)
            let renderer = UIGraphicsImageRenderer(size: size)
            let newImage = renderer.image { _ in
                image.draw(in: renderer.format.bounds)
            }
            return newImage
    }
}

extension MemberViewController: TabTitleViewDelegate {
    func selectPageTitleView(_ pageTitleView: TabTitleView, withIndex index: Int) {
        mPageContentView.setPageContentViewWithIndex(index)
    }
}

extension MemberViewController: TabContentViewDelegate {
    func scrollPageContentView(_ pageContentView: TabContentView,
                               progress: CGFloat,
                               originalIndex: Int,
                               targetIndex: Int) {
        mPageTitleView.setPageTitleViewWithProgress(progress,
                                                    originalIndex: originalIndex,
                                                    targetIndex: targetIndex)
    }
}

extension MemberViewController: PostCountDelegate {
    func getPostCount(postCount: Int) {
        DispatchQueue.main.async {
            self.pointLabel.text = String(postCount)
        }
    }
    
    func getLikeCount(likeCountList: [Int]) {
        let sum = likeCountList.reduce(0, +)
        DispatchQueue.main.async {
            self.followingLabel.text = String(sum)
        }
    }
}
