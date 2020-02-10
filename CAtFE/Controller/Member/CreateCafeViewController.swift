//
//  CreateCafeViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

enum CellType {
    case text
    case checkBox
    case bool
    case star
    case openTime
}

struct CellContent {
    var type: CellType
    var title: String
}

class CreateCafeViewController: BaseViewController {

    let contents: [CellContent] = [
        CellContent(type: .text, title: "店名（必填）"),
        CellContent(type: .text, title: "店家電話（必填）"),
        CellContent(type: .text, title: "店家地址（必填）"),
        CellContent(type: .text, title: "店家官網或FB粉專"),
        CellContent(type: .checkBox, title: "寵物類型（必填）"),
        CellContent(type: .star, title: "寵物親人"),
        CellContent(type: .star, title: "價格親人"),
        CellContent(type: .star, title: "用餐環境"),
        CellContent(type: .star, title: "餐點好吃"),
        CellContent(type: .star, title: "交通便利"),
        CellContent(type: .bool, title: "有提供 wifi"),
        CellContent(type: .bool, title: "插座多"),
        CellContent(type: .bool, title: "是否限時"),
        CellContent(type: .text, title: "最低消費金額"),
        CellContent(type: .openTime, title: "週一"),
        CellContent(type: .openTime, title: "週二"),
        CellContent(type: .openTime, title: "週三"),
        CellContent(type: .openTime, title: "週四"),
        CellContent(type: .openTime, title: "週五"),
        CellContent(type: .openTime, title: "週六"),
        CellContent(type: .openTime, title: "週日"),
        CellContent(type: .text, title: "備註：")
    ]

    @IBOutlet weak var tableView: UITableView!
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
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailCheckBoxTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailOpenTimeTableViewCell.self), bundle: nil)
    }

    func sendCafeData() {
        // TODO: Upload to api
    }
}

extension CreateCafeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1, 2, 3, 13, 21:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailTextTableViewCell.identifier, for: indexPath) as? CreateDetailTextTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        case 5, 6, 7, 8, 9:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailStarTableViewCell.identifier, for: indexPath) as? CreateDetailStarTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        case 10, 11, 12:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailBoolTableViewCell.identifier, for: indexPath) as? CreateDetailBoolTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailCheckBoxTableViewCell.identifier, for: indexPath) as? CreateDetailCheckBoxTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailOpenTimeTableViewCell.identifier, for: indexPath) as? CreateDetailOpenTimeTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        }

    }
}

extension CreateCafeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
