//
//  ClipRadiusWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class ClipRadiusWidget: WidgetBaseChildWrapper {

    var radius: CGFloat = 0

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)
        view.clipsToBounds = true
        view.layer.cornerRadius = radius
    }

    public func radius(_ radius: CGFloat) -> Self {
        self.radius = radius
        return self
    }

}
