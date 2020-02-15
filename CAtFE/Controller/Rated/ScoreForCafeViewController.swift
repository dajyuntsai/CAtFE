//
//  ScoreForCafeViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ScoreForCafeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    let starList: [CellContent] = [
        CellContent(type: .star, title: ""),
        CellContent(type: .star, title: "寵物親人"),
        CellContent(type: .star, title: "價格親人"),
        CellContent(type: .star, title: "用餐環境"),
        CellContent(type: .star, title: "餐點好吃"),
        CellContent(type: .star, title: "交通便利"),
        CellContent(type: .text, title: "備註")]
    
    @IBAction func sendScoreBtn(_ sender: Any) {
        // TODO: call api
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.registerCellWithNib(identifier: String(describing: UserTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailStarTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: NoteTableViewCell.self), bundle: nil)
    }
}

extension ScoreForCafeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier,
                                                           for: indexPath) as? UserTableViewCell else {
                return UITableViewCell()
            }
            cell.setData()
            return cell
        case 1, 2, 3, 4, 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailStarTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailStarTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: starList[indexPath.row].title)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier,
                                                           for: indexPath) as? NoteTableViewCell else {
                return UITableViewCell()
            }
            cell.setData()
            return cell
        }
    }
}

extension ScoreForCafeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 120
        case 1, 2, 3, 4, 5:
            return 60
        default:
            return 150
        }
    }
}
