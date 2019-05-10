//
//  TappableWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class TappableWidget: WidgetBaseChildWrapper {

    public var tapped: (() -> Void)?

    // default tap effect dims alpha of enclosed view
    var effect: ((_ view: UIView, _ completion: @escaping (() -> Void)) -> Void)? = { view, completion in
        let oldAlpha = view.alpha
        UIView.animate(withDuration: 0.05, animations: {
            view.alpha = max(view.alpha - 0.4, 0)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.05, animations: {
                view.alpha = oldAlpha
            }, completion: { completed in
                completion()
            })
        })
    }

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)

        if let tapped = self.tapped {
            let tapGesture = UITapGestureRecognizer()
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true

            tapGesture.rx.event
                .subscribe(onNext: { [tapped, effect] (gesture) in
                    if let effect = effect, let view = gesture.view {
                        effect(view, tapped)
                    } else {
                        tapped()
                    }
                })
                .disposed(by: context.disposeBag)
        }
    }

    public func effect(_ effect: @escaping ((_ view: UIView, _ completion: @escaping (() -> Void)) -> Void)) -> Self {
        self.effect = effect
        return self
    }

    public func onTap(_ tapped: @escaping () -> Void) -> Self {
        self.tapped = tapped
        return self
    }

}
