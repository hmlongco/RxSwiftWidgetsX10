//
//  WidgetBaseChildWrapper.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class WidgetBaseChildWrapper: WidgetBase<UIView>, WidgetChildManaging {

    required public init(_ child: Widget) {
        super.init()
        self.children = [child]
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        return child?.build(context)
    }

    override open func viewAddedToSuperview() {
        super.viewAddedToSuperview()
        children.first?.viewAddedToSuperview()
    }

}
