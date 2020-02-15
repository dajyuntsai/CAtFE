//
//  FollowingCafeEventViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class FollowingCafeEventViewController: BaseViewController {
    
    @IBOutlet weak var createPostBtn: UIButton!
    @IBOutlet weak var createBtnRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBAction func createEventBtn(_ sender: Any) {
        showCreatePostView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        createPostBtn.layer.cornerRadius = createPostBtn.frame.width / 2
        createBtnBottomConstraint.constant = -height * 0.28
        createBtnRightConstraint.constant = width * 0.05
    }
    
    func showCreatePostView() {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageViewController.identifier)
            as? PostMessageViewController
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
}

extension FollowingCafeEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowingCafeTableViewCell.identifier,
                                                       for: indexPath) as? FollowingCafeTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension FollowingCafeEventViewController: UITableViewDelegate {
    
}
