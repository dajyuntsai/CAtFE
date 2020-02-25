//
//  LoadingViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/25.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension UIViewController {
    func presentLoadingVC(completion: @escaping (() -> Void)) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: completion)
    }
}
