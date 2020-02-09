//
//  MemberViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    func initView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberInfoTableViewCell.identifier, for: indexPath) as? MemberInfoTableViewCell else {
                return UITableViewCell()
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension MemberViewController: UITableViewDelegate {
}
