//
//  DisclosableWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class DisclosableWidget: WidgetBaseChildWrapper {

    var disclose: (() -> Void)?

    // default tap effect dims alpha of view
    var effect: ((_ view: UIView, _ completion: @escaping (() -> Void)) -> Void)? = { view, completion in
        let oldAlpha = view.alpha
        UIView.animate(withDuration: 0.05, animations: {
            view.alpha = max(view.alpha - 0.4, 0)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.05, animations: {
                view.alpha = oldAlpha
            }, completion: { _ in
                completion()
            })
        })
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        guard let childView = child?.build(context) else { return nil }

        let enclosure = UIView()
        enclosure.backgroundColor = .clear
        enclosure.addSubview(childView)
        
        child?.viewAddedToSuperview()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\u{203A}"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = UIColor.init(white: 0.85, alpha: 1.0)
        label.backgroundColor = .clear
        enclosure.addSubview(label)

        enclosure.topAnchor.constraint(equalTo: childView.topAnchor).isActive = true
        enclosure.bottomAnchor.constraint(equalTo: childView.bottomAnchor).isActive = true
        enclosure.leadingAnchor.constraint(equalTo: childView.leadingAnchor).isActive = true
        enclosure.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true

        label.leadingAnchor.constraint(equalTo: childView.trailingAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: enclosure.centerYAnchor).isActive = true

        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)

        return enclosure
    }

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)

        guard let disclose = self.disclose else {
            return
        }

        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true

        tapGesture.rx.event
            .subscribe(onNext: { [disclose, effect] (gesture) in
                if let effect = effect, let view = gesture.view {
                    effect(view, disclose)
                } else {
                    disclose()
                }
            })
            .disposed(by: context.disposeBag)
    }

    public func effect(_ effect: @escaping ((_ view: UIView, _ completion: @escaping (() -> Void)) -> Void)) -> Self {
        self.effect = effect
        return self
    }

    public func onDisclose(_ disclose: @escaping () -> Void) -> Self {
        self.disclose = disclose
        return self
    }

}
