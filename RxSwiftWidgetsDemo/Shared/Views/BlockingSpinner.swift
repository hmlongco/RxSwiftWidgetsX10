//
//  BlockingSpinner.swift
//  CRI
//
//  Created by Michael Long on 4/6/17.
//  Copyright © 2017 Client Resources Inc. All rights reserved.
//

import RxSwift
import RxCocoa

import UIKit

class BlockingSpinner: NSObject {

    static let instance = BlockingSpinner()

    private static let spinnerContainerSize: CGFloat = 90
    private let view: UIView
    private let window: UIWindow
    private let spinner: UIActivityIndicatorView
    private var referenceCount: Int = 0
    private var mutex = pthread_mutex_t()

    override init() {
        window = BlockingSpinner.constructWindow()
        view = BlockingSpinner.constructView(from: window)
        spinner = BlockingSpinner.constructSpinner(from: view)
        super.init()
    }

    private static func constructWindow() -> UIWindow {
        let window = UIWindow()
        window.windowLevel = UIWindow.Level.alert
        window.isExclusiveTouch = true
        window.isHidden = true
        window.backgroundColor = UIColor.clear
        window.rootViewController = UIViewController()
        return window
    }

    private static func constructView(from window: UIWindow) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(view)
        view.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: BlockingSpinner.spinnerContainerSize).isActive = true
        view.widthAnchor.constraint(equalToConstant: BlockingSpinner.spinnerContainerSize).isActive = true
        return view
    }

    private static func constructSpinner(from view: UIView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = UIActivityIndicatorView.Style.whiteLarge
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return spinner
    }

    func animate(_ flag: Bool) {
        if flag {
            startAnimating()
        } else {
            stopAnimating()
        }
    }

    func startAnimating() {
        referenceCount += 1
        guard self.referenceCount > 0 && self.window.isHidden else { return }
        OperationQueue.main.addOperation {
            guard self.referenceCount > 0 && self.window.isHidden else { return }
            self.window.frame = UIScreen.main.bounds
            self.window.setNeedsLayout()
            self.spinner.startAnimating()
            self.view.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.view.alpha = 1
            }
            self.window.isHidden = false
        }
    }

    func stopAnimating() {
        guard referenceCount > 0 else { return }
        referenceCount -= 1
        guard self.referenceCount == 0 && self.window.isHidden == false else { return }
        OperationQueue.main.addOperation {
            guard self.referenceCount == 0 && self.window.isHidden == false else { return }
            self.spinner.stopAnimating()
            self.window.isHidden = true
        }
    }

    func hide() {
        guard referenceCount > 0 else { return }
        OperationQueue.main.addOperation {
            self.spinner.stopAnimating()
            self.window.isHidden = true
            self.referenceCount = 0
        }
    }

}

extension Reactive where Base: BlockingSpinner {
    var animate: Binder<Bool> {
        return Binder(self.base) { spinner, animating in
            spinner.animate(animating)
        }
    }
}

extension UIViewController {
    var blockingSpinner: BlockingSpinner {
        return BlockingSpinner.instance
    }
}

extension OperationQueue {
    func addBlockingOperation(_ block: @escaping () -> Swift.Void) {
        BlockingSpinner.instance.startAnimating()
        let op = BlockOperation(block: block)
        op.completionBlock = {
            BlockingSpinner.instance.stopAnimating()
        }
        addOperation(op)
    }
}
