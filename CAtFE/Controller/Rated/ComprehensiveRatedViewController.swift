//
//  RatedViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ComprehensiveRatedViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ComprehensiveRatedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatedTableViewCell.identifier, for: indexPath) as? RatedTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.ratedIcon.image = UIImage(named: "first")
        case 1:
            cell.ratedIcon.image = UIImage(named: "second")
        case 2:
            cell.ratedIcon.image = UIImage(named: "third")
        default:
            cell.ratedIcon.isHidden = true
        }
        return cell
    }
}

extension ComprehensiveRatedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
