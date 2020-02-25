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
    
    let scoreManager = ScoreManager()
    var starList: [CellContent] = [
        CellContent(type: .bool, title: ""),
        CellContent(type: .star, title: "寵物親人"),
        CellContent(type: .star, title: "價格親人"),
        CellContent(type: .star, title: "用餐環境"),
        CellContent(type: .star, title: "餐點好吃"),
        CellContent(type: .star, title: "交通便利"),
        CellContent(type: .text, title: "備註")]
    
    @IBAction func sendScoreBtn(_ sender: Any) {
        updateScoreForCafe()
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
    
    func updateScoreForCafe() {
        guard let token = KeyChainManager.shared.token else { return }
        scoreManager.createCafeScore(
            token: token,
            cafeId: 6,
            loveOne: starList[1].value[0] as? Double ?? 1.0,
            price: starList[2].value[0] as? Double ?? 1.0,
            surrounding: starList[3].value[0] as? Double ?? 1.0,
            meal: starList[4].value[0] as? Double ?? 1.0,
            traffic: starList[5].value[0] as? Double ?? 1.0) { (result) in
                switch result {
                case .success:
                    CustomProgressHUD.showSuccess(text: "已完成評分")
                case .failure:
                    CustomProgressHUD.showFailure(text: "評分失敗")
                }
        }
    }
}

extension ScoreForCafeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listType = starList[indexPath.row].type
        switch listType {
        case .star:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailStarTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailStarTableViewCell else {
                return UITableViewCell()
            }
            cell.starCount = { score in
                self.starList[indexPath.row].value = score
            }
            cell.setData(title: starList[indexPath.row].title)
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier,
                                                           for: indexPath) as? NoteTableViewCell else {
                return UITableViewCell()
            }
            cell.setData()
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier,
                                                           for: indexPath) as? UserTableViewCell else {
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
