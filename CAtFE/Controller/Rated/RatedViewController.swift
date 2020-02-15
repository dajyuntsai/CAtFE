//
//  RatedViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class RatedViewController: UIViewController {

    private var mPageTitleView: TabTitleView!
    private var mPageContentView: TabContentView!
    private var scrollView = UIScrollView()
    private var titleList = ["總榜", "寵物親人", "價格親人", "用餐環境", "餐點好吃", "交通便利"]
    let conf = TabTitleConfig()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        let rectTitle = CGRect(x: 0, y: 90, width: width, height: 60)
        mPageTitleView = TabTitleView(frame: rectTitle, titleArr: titleList, config: conf, delegate: self)
        self.view.addSubview(mPageTitleView)
        
        guard let comprehensiveVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        guard let petVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        guard let priceVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        guard let ambienceVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        guard let deliciousVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        guard let convenienceVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        
        let controllers = [comprehensiveVC,
                           petVC, priceVC,
                           ambienceVC,
                           deliciousVC,
                           convenienceVC]
        let rectContent = CGRect(x: 0, y: 150, width: width, height: height)
        mPageContentView = TabContentView(frame: rectContent, parentVC: self,
                                          childVCs: controllers,
                                          childViews: [],
                                          delegate: self)
        self.view.addSubview(mPageContentView)
    }
}

extension RatedViewController: TabTitleViewDelegate {
    func selectPageTitleView(_ pageTitleView: TabTitleView, withIndex index: Int) {
        mPageContentView.setPageContentViewWithIndex(index)
    }
}

extension RatedViewController: TabContentViewDelegate {
    func scrollPageContentView(_ pageContentView: TabContentView,
                               progress: CGFloat,
                               originalIndex: Int,
                               targetIndex: Int) {
        mPageTitleView.setPageTitleViewWithProgress(progress,
                                                    originalIndex: originalIndex,
                                                    targetIndex: targetIndex)
    }
}
