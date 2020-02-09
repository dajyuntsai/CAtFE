//
//  CreateCafeViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class CreateCafeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let textList = ["店名：", "店家電話：", "店家地址：", "店家官網或FB粉專：", "最低消費金額"]
    let petList = ["寵物類型："]
    let boolList = ["有提供 wifi：", "插座多：", "是否限時"]
    let commentList = ["寵物親人：", "價格親人：", "用餐環境：", "餐點好吃：", "交通便利："]
    let openTimeList = ["週一", "週二", "週三", "週四", "週五", "週六", "週日"]

    @IBAction func sendCafeBtn(_ sender: Any) {
        sendCafeData()
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }

    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
        
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailTextTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailStarTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailBoolTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailOpenTimeTableViewCell.self), bundle: nil)
    }

    func sendCafeData() {
        // TODO: Upload to api
    }
}

extension CreateCafeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textList.count + petList.count + boolList.count + commentList.count + openTimeList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1, 2, 3, 13:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailTextTableViewCell.identifier, for: indexPath) as? CreateDetailTextTableViewCell else {
                return UITableViewCell()
            }
//            cell.titleLabel.text = textList[indexPath.row]
            return cell
        case 5, 6, 7, 8, 9:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailStarTableViewCell.identifier, for: indexPath) as? CreateDetailStarTableViewCell else {
                return UITableViewCell()
            }
//            cell.titleLabel.text = commentList[indexPath.row]
            return cell
        case 10, 11, 12:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailBoolTableViewCell.identifier, for: indexPath) as? CreateDetailBoolTableViewCell else {
                return UITableViewCell()
            }
//            cell.descLabel.text = boolList[indexPath.row]
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailOpenTimeTableViewCell.identifier, for: indexPath) as? CreateDetailOpenTimeTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }

    }
}

extension CreateCafeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
