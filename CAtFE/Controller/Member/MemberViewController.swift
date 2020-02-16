//
//  MemberViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    private var mPageTitleView: TabTitleView!
    private var mPageContentView: TabContentView!
    private var scrollView = UIScrollView()

    private var titleList = ["我的留言", "追蹤的店家"]

    let conf = TabTitleConfig()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    @IBAction func settingBtn(_ sender: Any) {
        onUsetSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTabView()
        initBarBtn()
    }

    func initView() { // TODO: 往上滑的時候消失
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }

    func initTabView() {
        let rectTitle = CGRect(x: 0, y: height * 0.1 + 150, width: width, height: 50)
        mPageTitleView = TabTitleView(frame: rectTitle, titleArr: titleList, config: conf, delegate: self)
        self.view.addSubview(mPageTitleView)

        guard let myMessagesViewController = UIStoryboard.member
            .instantiateViewController(identifier: MyMessagesViewController.identifier)
            as? MyMessagesViewController else { return }
        guard let myFollowingViewController = UIStoryboard.member
            .instantiateViewController(identifier: MyFollowingViewController.identifier)
            as? MyFollowingViewController else { return }
        let controllers = [myMessagesViewController, myFollowingViewController]
        let rectContent = CGRect(x: 0, y: height * 0.1 + 150 + 50, width: width, height: height)
        mPageContentView = TabContentView(frame: rectContent, parentVC: self,
                                          childVCs: controllers,
                                          childViews: [],
                                          delegate: self)
        self.view.addSubview(mPageContentView)
    }
    
    func initBarBtn() {
        if let image = UIImage(named: "settings") {
            let smallImage = resizeImage(image: image, width: 28)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: smallImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onUsetSetting))
        }
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
            let newImage = renderer.image { (context) in
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
