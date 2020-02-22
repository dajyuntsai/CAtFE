//
//  ShopEventsViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ShopEventsViewController: UIViewController {

    private var mPageTitleView: TabTitleView!
    private var mPageContentView: TabContentView!
    private var scrollView = UIScrollView()
    private var titleList = ["我追蹤的", "熱門", "為你推薦"]
    let conf = TabTitleConfig()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initView() {
        let rectTitle = CGRect(x: 0, y: height * 0.1, width: width, height: 50)
        mPageTitleView = TabTitleView(frame: rectTitle, titleArr: titleList, config: conf, delegate: self)
        self.view.addSubview(mPageTitleView)
        
        guard let myFollowingVC = UIStoryboard.shopEvent
            .instantiateViewController(identifier: FollowingCafeEventViewController.identifier)
            as? FollowingCafeEventViewController else { return }
        guard let hotVC = UIStoryboard.shopEvent
            .instantiateViewController(identifier: FollowingCafeEventViewController.identifier)
            as? FollowingCafeEventViewController else { return }
        guard let recommandVC = UIStoryboard.shopEvent
            .instantiateViewController(identifier: FollowingCafeEventViewController.identifier)
            as? FollowingCafeEventViewController else { return }
        
        let controllers = [myFollowingVC,
                           hotVC,
                           recommandVC]
        let rectContent = CGRect(x: 0, y: height * 0.1 + 60, width: width, height: height)
        mPageContentView = TabContentView(frame: rectContent, parentVC: self,
                                          childVCs: controllers,
                                          childViews: [],
                                          delegate: self)
        self.view.addSubview(mPageContentView)
    }
}

extension ShopEventsViewController: TabTitleViewDelegate {
    func selectPageTitleView(_ pageTitleView: TabTitleView, withIndex index: Int) {
        mPageContentView.setPageContentViewWithIndex(index)
    }
}

extension ShopEventsViewController: TabContentViewDelegate {
    func scrollPageContentView(_ pageContentView: TabContentView,
                               progress: CGFloat,
                               originalIndex: Int,
                               targetIndex: Int) {
        mPageTitleView.setPageTitleViewWithProgress(progress,
                                                    originalIndex: originalIndex,
                                                    targetIndex: targetIndex)
    }
}
