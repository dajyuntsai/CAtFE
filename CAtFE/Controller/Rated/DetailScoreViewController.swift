//
//  DetailScoreViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import AAInfographics

class DetailScoreViewController: BaseViewController {

    open var chartType: Int!
    open var aaChartModel: AAChartModel!
    open var aaChartView: AAChartView!
    
    var cafeRating: Cafe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpAAChartView()
        setNavigationItem()
    }
    
    func setUpAAChartView() {
        aaChartView = AAChartView()
        let chartWidth = view.frame.size.width
        let chartHeight = view.frame.size.height
        aaChartView!.frame = CGRect(x: 0,
                                    y: 20,
                                    width: chartWidth,
                                    height: chartHeight)
        aaChartView!.contentHeight = chartWidth
        view.addSubview(aaChartView!)
        aaChartView!.scrollEnabled = false
        aaChartModel = configurePentagonRadarChart()
        aaChartView!.aa_drawChartWithChartModel(aaChartModel!)
    }
    
    private func configurePentagonRadarChart() -> AAChartModel {
        return AAChartModel()
            .chartType(.area)
            .animationType(.easeOutQuint)
            .title(cafeRating?.name ?? "Cafe Name")
            .titleFontSize(18)
            .subtitle("平均分數")
            .subtitleFontSize(15)
            .categories(["寵物親人", "價格親人", "用餐環境", "餐點好吃", "交通便利"])
            .colorsTheme(["#ffc069"])
            .dataLabelsEnabled(false)
            .xAxisVisible(true)
            .markerRadius(0)
            .polar(true)
            .series([
                AASeriesElement()
//                    .name(" 平均分數")
                    .data([cafeRating?.loveOneAverage as Any,
                           cafeRating?.priceAverage as Any,
                           cafeRating?.surroundingAverage as Any,
                           cafeRating?.mealAverage as Any,
                           cafeRating?.trafficAverage as Any])
            ])
    }
    
    func setNavigationItem() {
        let addScoreBtn = UIBarButtonItem(title: "我要評分",
                                          style: .plain,
                                          target: self,
                                          action: #selector(showRatedStarView))
        self.navigationItem.rightBarButtonItem  = addScoreBtn
    }
    
    @objc func showRatedStarView() {
        if KeyChainManager.shared.token == nil {
            alert(message: "登入後才能評分喔！", title: "溫馨小提醒", handler: nil)
        }
        let presentVC = UIStoryboard.rated
            .instantiateViewController(identifier: ScoreForCafeViewController.identifier)
            as? ScoreForCafeViewController
        presentVC?.modalPresentationStyle = .fullScreen
        presentVC?.cafeRating = self.cafeRating
        self.show(presentVC!, sender: nil)
    }
}
