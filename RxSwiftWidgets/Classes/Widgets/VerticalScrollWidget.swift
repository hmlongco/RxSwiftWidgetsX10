//
//  VerticalScrollWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class VerticalScrollWidget: ScrollWidget {

    required public init(_ child: Widget) {
        super.init(child)
        self.contentsShouldAvoidKeyboard = true
    }

    override open func applyConstraints() {
        super.applyConstraints()

        guard let view = view, let superview = view.superview, let subview = view.subviews.first else { return }

        subview.widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
}
