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
//        NotificationCenter.default.addObserver(self, selector: #selector(stop), name: Notification.Name("closeLoading"), object: nil)
    }
    
    @objc func stop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true, completion: nil)
        }
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
