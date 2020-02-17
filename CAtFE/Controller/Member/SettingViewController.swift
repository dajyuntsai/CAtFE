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

class SettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    let height = UIScreen.main.bounds.height
    let settingList: [Settings] = [
        Settings(title: "個人資料", details: ["頭像", "名稱"]),
        Settings(title: "推播通知", details: []),
        Settings(title: "版本", details: []),
        Settings(title: "登出", details: [])]
    var isExpendDataList: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUptTableView()
        
        for _ in settingList {
            isExpendDataList.append(false)
        }
    }
    
    func setUptTableView() {
        tableView.registerHeaderWithNib(identifier: String(describing: SectionView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: UserInfoTableViewCell.self), bundle: nil)
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
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier,
                                                           for: indexPath) as? UserInfoTableViewCell else {
                                                            return UITableViewCell()
            }
            let data = settingList[indexPath.section].details[indexPath.row]
            if indexPath.row == 0 {
                cell.userNameTextField.isHidden = true
            } else {
                cell.userImageView.isHidden = true
            }
            cell.setData(data: data)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 150
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: String(describing: SectionView.self))
            as? SectionView else {
            return UIView()
        }
        
        if section == 2 || section == 3 {
            sectionView.expandBtn.isHidden = true
        }
        
        sectionView.isExpand = self.isExpendDataList[section]
        sectionView.buttonTag = section
        sectionView.delegate = self
        
        sectionView.setData(data: settingList[section])
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 //height / 12
    }
}

extension SettingViewController: SectionViewDelegate {
    func sectionView(_ sectionView: SectionView, _ didPressTag: Int, _ isExpand: Bool) {
        self.isExpendDataList[didPressTag] = !isExpand
        self.tableView.reloadSections(IndexSet(integer: didPressTag), with: .automatic)
    }
}
