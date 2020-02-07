//
//  CreateCafeViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class CreateCafeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }

    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailTableViewCell.self), bundle: nil)
    }
}

extension CreateCafeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailTableViewCell.identifier, for: indexPath) as? CreateDetailTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension CreateCafeViewController: UITableViewDelegate {
    
}
