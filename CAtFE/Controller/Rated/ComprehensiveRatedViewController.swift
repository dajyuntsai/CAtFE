//
//  RatedViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ComprehensiveRatedViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
        
    let animation = Animation()
    let refreshControl = UIRefreshControl()
    let scoreManager = ScoreManager()

    var ratedList: [Cafe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        getRatedList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
//        getRatedList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initView() {
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func getRatedList() {
        scoreManager.getRatedList { (result) in
            switch result {
            case .success(let data):
                self.getSortedRank(cafeList: data.results)
            case .failure(let error):
                CustomProgressHUD.showFailure(text: "讀取資料失敗")
            }
        }
    }
    
    func getSortedRank(cafeList: [Cafe]) {
        ratedList = cafeList.sorted {
            ($0.loveOneAverage + $0.mealAverage + $0.priceAverage + $0.surroundingAverage + $0.trafficAverage) / 5 >
                ($1.loveOneAverage + $1.mealAverage + $1.priceAverage + $1.surroundingAverage + $1.trafficAverage) / 5}
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        cell.setData(data: ratedList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ComprehensiveRatedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 進入點店家網站
        performSegue(withIdentifier: "showWebView", sender: self)
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
        presentVC?.ratedList = self.ratedList[indexPath.row]
        self.show(presentVC!, sender: nil)
    }
    
    func getBtnState(_ cell: RatedTableViewCell, _ btnState: Bool) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.reloadData()
    }
}
