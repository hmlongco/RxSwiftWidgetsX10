//
//  SafeAreaWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class SafeAreaWidget: WidgetBase<UIView>, WidgetChildManaging {

    required public init(_ child: Widget) {
        super.init()
        self.children = [child]
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        return UIView()
    }

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        view.backgroundColor = .clear

        super.applyProperties(to: view, with: context)

        if let subview = child?.build(context) {
            view.addSubview(subview)
            child?.viewAddedToSuperview()
        }
    }

    override open func applyConstraints() {
        super.applyConstraints()

        guard let view = view, let subview = view.subviews.first else { return }

        if #available(iOS 11.0, *) {
            let guide = view.safeAreaLayoutGuide
            subview.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            subview.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            subview.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            subview.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        } else {
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            subview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

    }

}
