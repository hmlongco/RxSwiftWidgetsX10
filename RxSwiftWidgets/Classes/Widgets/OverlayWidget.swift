//
//  OverlayWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

// Note most of the heavy lifting is done by WidgetBaseContainer

open class OverlayWidget: WidgetBaseContainer<UIView>, WidgetChildrenManaging {

    required public init(_ children: [Widget]) {
        super.init()
        self.children = children
        self.position = .fill
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)

        children.forEach { child in
            if let subview = child.build(context) {
                view.addSubview(subview)
                child.viewAddedToSuperview()
            }
        }
    }
    
}

extension OverlayWidget
    {}
