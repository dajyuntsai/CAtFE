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
    
    var scoreList = [5, 4, 3, 4, 4]
    
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
        aaChartView!.contentHeight = chartHeight / 2
        view.addSubview(aaChartView!)
        aaChartView!.scrollEnabled = false
        aaChartModel = configurePentagonRadarChart()
        aaChartView!.aa_drawChartWithChartModel(aaChartModel!)
    }
    
    private func configurePentagonRadarChart() -> AAChartModel {
        return AAChartModel()
            .chartType(.area)
            .animationType(.easeOutQuint)
            .title("Cafe Name")
            .titleFontSize(18)
            .subtitle("average score")
            .subtitleFontSize(15)
            .categories(["寵物親人", "價格親人", "用餐環境", "餐點好吃", "交通便利"])
            .colorsTheme(["#ffc069"])
            .dataLabelsEnabled(false)
            .xAxisVisible(true)
            .markerRadius(0)
            .polar(true)
            .series([
                AASeriesElement()
                    .name(" 平均分數")
                    .data(scoreList)
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
        let presentVC = UIStoryboard.rated
            .instantiateViewController(identifier: ScoreForCafeViewController.identifier)
            as? ScoreForCafeViewController
        presentVC?.modalPresentationStyle = .fullScreen
        self.show(presentVC!, sender: nil)
    }
}
