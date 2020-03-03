//
//  MyFollowingViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/11.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MyFollowingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    let refreshControl = UIRefreshControl()
    let userProvider = UserProvider()
    var cafeList: [Cafe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getFollowingCafe), name: Notification.Name("updateFollowing"), object: nil)
        
        getFollowingCafe()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func getFollowingCafe() {
        cafeList.removeAll()
        guard let token = KeyChainManager.shared.token else { return }
        userProvider.getUserFollowing(token: token) { (result) in
            switch result {
            case .success(let data):
                RatedObject.shared.followingCafes = data.data
                self.cafeList = data.data
            case .failure:
                CustomProgressHUD.showFailure(text: "讀取資料失敗")
            }
        }
    }

    @objc func loadData() {
        cafeList.removeAll()
        getFollowingCafe()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension MyFollowingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFollowingViewTableViewCell.identifier,
                                                       for: indexPath) as? MyFollowingViewTableViewCell else {
            return UITableViewCell()
        }
        cell.setData(data: cafeList[indexPath.row])
        return cell
    }
}

extension MyFollowingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            // TODO: 再打一次api
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消追蹤"
    }
}
