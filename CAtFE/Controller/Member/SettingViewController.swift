//
//  SettingViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

struct Settings {
    let title: String
    let details: [String]
}

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    let settingList: [Settings] = [
        Settings(title: "個人資料", details: ["頭像", "名稱"]),
        Settings(title: "推播通知", details: []),
        Settings(title: "版本", details: [])]
    var isExpendDataList: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpendDataList[section] {
            return settingList[section].details.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SettingViewController: UITableViewDelegate {
    
}
