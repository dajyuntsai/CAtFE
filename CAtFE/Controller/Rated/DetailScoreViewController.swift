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
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var cafeRating: Cafe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBackBtn()
        initScoreBtn()
        setUpAAChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initBackBtn() {
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: width * 0.05, y: height * 0.07, width: width * 0.1, height: width * 0.1)
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.backgroundColor = .lightGray
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    func initScoreBtn() {
        let scoreBtn = UIButton()
        scoreBtn.frame = CGRect(x: width - (width * 0.05 + width * 0.1) - 50, y: height * 0.07, width: width * 0.2, height: width * 0.1)
        scoreBtn.setTitle("我要評分", for: .normal)
        scoreBtn.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        scoreBtn.addTarget(self, action: #selector(showRatedStarView), for: .touchUpInside)
        self.view.addSubview(scoreBtn)
    }
    
    func setUpAAChartView() {
        aaChartView = AAChartView()
        let chartWidth = view.frame.size.width
        let chartHeight = view.frame.size.height
        aaChartView!.frame = CGRect(x: 0,
                                    y: height * 0.07 + 50,
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
    
    @objc func back() {
        navigationController?.popToRootViewController(animated: true)
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
