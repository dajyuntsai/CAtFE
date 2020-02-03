//
//  PostMessageViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }
}

extension PostMessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostUserInfoCell", for: indexPath) as? PostMessageUserTableViewCell else { return UITableViewCell() }
            
            return cell
//        case 1:
            
        default:
            return UITableViewCell()
        }
    }
}
