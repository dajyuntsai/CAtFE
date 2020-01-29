//
//  UIAlertView+Extension.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/29.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
