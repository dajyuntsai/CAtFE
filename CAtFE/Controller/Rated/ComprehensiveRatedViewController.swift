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
    
    let group = DispatchGroup()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let animation = Animation()
    let refreshControl = UIRefreshControl()
    let scoreManager = ScoreManager()
    let cafeManager = CafeManager()
    let userProvider = UserProvider()

    var index = 0
    var ratedList: [Cafe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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
        let loadingVC = presentLoadingVC()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        getFollowingCafes {}
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            loadingVC.dismiss(animated: true, completion: nil)
        }
    }
    
    func getFollowingCafes(completion: @escaping (() -> Void)) {
        guard let token = KeyChainManager.shared.token else { return }
        group.enter()
        userProvider.getUserFollowing(token: token) { (result) in
            switch result {
            case .success(let data):
                RatedObject.shared.followingCafes.removeAll()
                RatedObject.shared.followingCafes = data.data
                completion()
            case .failure(let error):
                print("======= getFollowingCafes() error: \(error.localizedDescription)")
            }
            self.group.leave()
        }
    }
    
    func addFollowingCafe(_ cell: RatedTableViewCell, completion: @escaping (() -> Void )) {
        guard let token = KeyChainManager.shared.token else {
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cafeId = ratedList[indexPath.row].id
        cafeManager.addFollowingCafe(token: token, cafeId: cafeId) { (result) in
            switch result {
            case .success:
                print("=======追蹤成功")
                DispatchQueue.main.async {
                    self.getFollowingCafes {
                        completion()
                    }
                }
                NotificationCenter.default.post(name: Notification.Name("updateFollowing"), object: nil)
            case .failure:
                CustomProgressHUD.showFailure(text: "追蹤失敗")
            }
        }
    }
    
    @objc func loadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension ComprehensiveRatedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatedTableViewCell.identifier, for: indexPath) as? RatedTableViewCell else {
            return UITableViewCell()
        }
        
        cell.followBtnState = false
        for following in RatedObject.shared.followingCafes
            where following.id == ratedList[indexPath.row].id {
                cell.followBtn.isSelected = true
                cell.followBtnState = true
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
            let loadingVC = presentLoadingVC()
            prsentVC.cafeUrl = ratedList[indexPath.row].fbUrl
            self.show(prsentVC, sender: nil)
            loadingVC.dismiss(animated: true, completion: nil)
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
    
    func getBtnState(_ cell: RatedTableViewCell) {
        if KeyChainManager.shared.token != nil {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            self.addFollowingCafe(cell) {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        } else {
            alert(message: "登入後才能收藏喔！", title: "溫馨小提醒") { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
