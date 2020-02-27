//
//  RatedViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

enum RatedCategory {
    case overAll
    case pet
    case price
    case surrounding
    case meal
    case traffic
}

class ComprehensiveRatedViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var index = 0
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let animation = Animation()
    let refreshControl = UIRefreshControl()
    let scoreManager = ScoreManager()

    var cafeList: [Cafe] = []
    var ratedList: [Cafe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        getRatedList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        getRatedList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initView() {
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private var sortedType: RatedCategory = .overAll
    
    func setSortType(rateCategory: RatedCategory) {
        sortedType = rateCategory
    }
    
    func getRatedList() {
        scoreManager.getRatedList { (result) in
            switch result {
            case .success(let data):
                self.cafeList = data.results
                
                switch self.sortedType {
                case .overAll:
                    self.ratedList = self.cafeList.sorted {
                    ($0.loveOneAverage + $0.mealAverage + $0.priceAverage + $0.surroundingAverage + $0.trafficAverage) / 5 >
                        ($1.loveOneAverage + $1.mealAverage + $1.priceAverage + $1.surroundingAverage + $1.trafficAverage) / 5}
                    self.index = 5
                case .meal:
                    self.ratedList = self.cafeList.sorted { $0.mealAverage > $1.mealAverage }
                    self.index = 1
                case .pet:
                    self.ratedList = self.cafeList.sorted { $0.loveOneAverage > $1.loveOneAverage }
                    self.index = 2
                case .price:
                    self.ratedList = self.cafeList.sorted { $0.priceAverage > $1.priceAverage }
                    self.index = 3
                case .surrounding:
                    self.ratedList = self.cafeList.sorted { $0.surroundingAverage > $1.surroundingAverage }
                    self.index = 4
                case .traffic:
                    self.ratedList = self.cafeList.sorted { $0.trafficAverage > $1.trafficAverage }
                    self.index = 0
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure:
                CustomProgressHUD.showFailure(text: "讀取資料失敗")
            }
            
        }
    }
    
    @objc func loadData() {
        getRatedList()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension ComprehensiveRatedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatedTableViewCell.identifier,
                                                       for: indexPath) as? RatedTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ratedIcon.isHidden = false
        switch indexPath.row {
        case 0:
            cell.ratedIcon.image = UIImage(named: "first")
        case 1:
            cell.ratedIcon.image = UIImage(named: "second")
        case 2:
            cell.ratedIcon.image = UIImage(named: "third")
        default:
            cell.ratedIcon.isHidden = true
        }
        
        let data = ratedList[indexPath.row]
        switch self.index {
        case 0:
            cell.setData(data: data, score: data.trafficAverage)
        case 1:
            cell.setData(data: data, score: data.mealAverage)
        case 2:
            cell.setData(data: data, score: data.loveOneAverage)
        case 3:
            cell.setData(data: data, score: data.priceAverage)
        case 4:
            cell.setData(data: data, score: data.surroundingAverage)
        default:
            let overAllScore = (data.loveOneAverage + data.mealAverage + data.priceAverage + data.surroundingAverage + data.trafficAverage) / 5
            cell.setData(data: data, score: overAllScore)
        }
        cell.delegate = self
        return cell
    }
}

extension ComprehensiveRatedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prsentVC = CafeWebsiteViewController()
        if ratedList[indexPath.row].fbUrl.isEmpty || ratedList[indexPath.row].fbUrl == "nil"{
            alert(message: "店家目前沒有架設網站喔！", handler: nil)
        } else {
            prsentVC.cafeUrl = ratedList[indexPath.row].fbUrl
            self.show(prsentVC, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animation.setTableViewSpringAnimate(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
}

extension ComprehensiveRatedViewController: RatedCellBtnDelegate {
    func showDetailRadar(_ cell: RatedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let presentVC = UIStoryboard.rated
            .instantiateViewController(identifier: DetailScoreViewController.identifier)
            as? DetailScoreViewController
        presentVC?.modalPresentationStyle = .fullScreen
        presentVC?.cafeRating = self.ratedList[indexPath.row]
        self.show(presentVC!, sender: nil)
    }
    
    func getBtnState(_ cell: RatedTableViewCell, _ btnState: Bool) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.reloadData()
    }
}
