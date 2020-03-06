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
    let scoreManager = ScoreManager()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var controllers: [ComprehensiveRatedViewController] = []
    var sortedTypes: [RatedCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initNavView()
        getRatedList()
    }
    
    func initNavView() {
        let navView = UILabel(frame: CGRect(x: width * 0.1, y: height * 0.06, width: width, height: 50))
        navView.text = "排行榜"
        navView.font = UIFont(name: "Helvetica Neue", size: 24)
        self.view.addSubview(navView)
    }
    
    func initView() {
        let rectTitle = CGRect(x: 0, y: height * 0.06 + 50, width: width, height: 50)
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
        guard let surroundingVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        guard let deliciousVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        guard let convenienceVC = UIStoryboard.rated
            .instantiateViewController(identifier: ComprehensiveRatedViewController.identifier)
            as? ComprehensiveRatedViewController else { return }
        
        controllers = [comprehensiveVC,
                       petVC,
                       priceVC,
                       surroundingVC,
                       deliciousVC,
                       convenienceVC]
        let rectContent = CGRect(x: 0, y: height * 0.06 + 50 + 50, width: width, height: height - (height * 0.06 + 70))
        mPageContentView = TabContentView(frame: rectContent, parentVC: self,
                                          childVCs: controllers,
                                          childViews: [],
                                          delegate: self)
        self.view.addSubview(mPageContentView)
    }
    
    func getRatedList() {
        let loadingVC = presentLoadingVC()
        scoreManager.getRatedList { (result) in
            switch result {
            case .success(let data):
                self.sortedResult(data: data.results)
            case .failure:
                CustomProgressHUD.showFailure(text: "讀取資料失敗")
            }
            DispatchQueue.main.async {
                loadingVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func sortedResult(data: [Cafe]) {
        for (index, controller) in controllers.enumerated() {
            switch index {
            case 0:
                controller.ratedList = self.scoreManager.sortByOverAll(data: data)
            case 1:
                controller.ratedList = self.scoreManager.sortByMeal(data: data)
            case 2:
                controller.ratedList = self.scoreManager.sortByPet(data: data)
            case 3:
                controller.ratedList = self.scoreManager.sortByPrice(data: data)
            case 4:
                controller.ratedList = self.scoreManager.sortBySurrounding(data: data)
            case 5:
                controller.ratedList = self.scoreManager.sortByTraffic(data: data)
            default:
                return
            }
        }
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
