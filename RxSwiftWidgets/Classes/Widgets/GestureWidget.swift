//
//  GestureWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class GestureWidget: TappableWidget {

    var swipeLeft: (() -> Void)?
    var swipeRight: (() -> Void)?

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)

        if let swipe = self.swipeLeft {
            let swipeGesture = UISwipeGestureRecognizer()
            swipeGesture.direction = .left
            view.addGestureRecognizer(swipeGesture)
            view.isUserInteractionEnabled = true

            swipeGesture.rx.event
                .subscribe(onNext: { [swipe] (gesture) in
                    swipe()
                })
                .disposed(by: context.disposeBag)
        }

        if let swipe = self.swipeRight {
            let swipeGesture = UISwipeGestureRecognizer()
            swipeGesture.direction = .right
            view.addGestureRecognizer(swipeGesture)
            view.isUserInteractionEnabled = true

            swipeGesture.rx.event
                .subscribe(onNext: { [swipe] (gesture) in
                    swipe()
                })
                .disposed(by: context.disposeBag)
        }
    }

    public func onSwipeLeft(_ swipe: @escaping () -> Void) -> Self {
        self.swipeLeft = swipe
        return self
    }

    public func onSwipeRight(_ swipe: @escaping () -> Void) -> Self {
        self.swipeRight = swipe
        return self
    }

}
