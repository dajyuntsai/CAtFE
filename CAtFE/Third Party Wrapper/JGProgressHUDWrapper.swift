//
//  JGProgressHUDWrapper.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/25.
//  Copyright © 2020 Ninn. All rights reserved.
//

import JGProgressHUD

enum HUDType {
    case success(String)
    case failure(String)
}

class CustomProgressHUD {
    static let shared = CustomProgressHUD()
    private init() { }
    let hud = JGProgressHUD(style: .dark)
    var view: UIView {
        return AppDelegate.shared.window!.rootViewController!.view
    }

    static func show(type: HUDType) {
        switch type {
        case .success(let text):
            showSuccess(text: text)
        case .failure(let text):
            showFailure(text: text)
        }
    }

    static func showSuccess(text: String = "Success") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showSuccess(text: text)
            }
            return
        }

        shared.hud.textLabel.text = text
        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        shared.hud.show(in: shared.view)
        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func showFailure(text: String = "Failure") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showFailure(text: text)
            }
            return
        }

        shared.hud.textLabel.text = text
        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        shared.hud.show(in: shared.view)
        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func show() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                show()
            }
            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        shared.hud.textLabel.text = "Loading"
        shared.hud.show(in: shared.view)
    }

    static func dismiss() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                dismiss()
            }
            return
        }
        shared.hud.dismiss()
    }
}
