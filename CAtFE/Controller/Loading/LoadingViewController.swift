//
//  LoadingViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/25.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Lottie

let loadingVC = LoadingViewController()

class LoadingViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
}

extension UIViewController {
    func presentLoadingVC() {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
    }
}
