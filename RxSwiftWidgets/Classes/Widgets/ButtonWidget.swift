//
//  ButtonWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class ButtonWidget: WidgetBase<UIButton> {

    internal var tap: ((_ view: UIView) -> Void)?
    internal var tapObserver: BehaviorSubject<Observable<Void>>?

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

    override open func buildInitialView(with context: WidgetContext) -> UIButton {
        return UIButton()
    }

    override open func applyProperties(to view: UIButton, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)

        if let padding = padding {
            view.contentEdgeInsets = padding
        }

        if let tap = self.tap {
            view.rx.tap
                .subscribe(onNext: { [weak view, effect, tap] _ in
                    guard let view = view else { return }
                    if let effect = effect {
                        effect(view) {
                            tap(view)
                       }
                    } else {
                        tap(view)
                    }
                })
                .disposed(by: context.disposeBag)
        }

        if let tapObserver = self.tapObserver {
            tapObserver.onNext(view.rx.tap.asObservable())
        }
    }

    override open func apply(property: WidgetProperty, with context: WidgetContext) {
        guard let button = view as? UIButton else { return }

        switch property {

        case let property as WidgetPropertyText:
            button.setTitle(property.text, for: .normal)

        case let property as WidgetPropertyTextColor:
            button.setTitleColor(property.color, for: .normal)

        case let property as WidgetPropertyTextFont:
            button.titleLabel?.font = property.font

        default:
            super.apply(property: property, with: context)
        }
    }

    override open func applyConstraints() {
        guard let view = view else { return }
        super.applyConstraints()
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    public func onTap(_ tap: @escaping (_ view: UIView) -> Void) -> Self {
        self.tap = tap
        return self
    }

    public func onTap(observer: inout Observable<Void>?) -> Self {
        tapObserver = BehaviorSubject<Observable<Void>>(value: Observable.never())
        observer = tapObserver!.switchLatest()
        return self
    }

}

extension ButtonWidget:
    WidgetPropertyPaddingSupported,
    WidgetPropertyTextSupported,
    WidgetPropertyTextColorSupported,
    WidgetPropertyTextFontSupported
    {}
