//
//  PostMessageDetailViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var message: Message?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func loadData() {
        // TODO: calling api
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension PostMessageDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell", for: indexPath) as? PostMessageDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(data: message!)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostAddReplyCell", for: indexPath) as? PostMessageAddReplyTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as? PostMessageReplyTableViewCell else {
            return UITableViewCell() }
            
            cell.replayContentLabel.text = "一個留言"
            return cell
        }
    }
}

extension PostMessageDetailViewController: UITableViewDelegate {

}
