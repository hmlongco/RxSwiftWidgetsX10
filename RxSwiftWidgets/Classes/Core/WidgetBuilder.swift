//
//  WidgetBuilder.swift
//  Widgets
//
//  Created by Michael Long on 3/3/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Building

open class WidgetBuilder {

    static public func add(widget: Widget, to view: UIView, with context: WidgetContext) {
        if let widgetView = widget.build(context) {
            view.addSubview(widgetView)
            WidgetPosition.fill.constrain(parent: view, child: widgetView, with: .zero)
            widget.viewAddedToSuperview()
        }
    }

    static public func view(for widget: Widget, with context: WidgetContext) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        add(widget: widget, to: view, with: context)
        return view
    }

}

public extension UIView {

    func add(widget: Widget, with context: WidgetContext) {
        WidgetBuilder.add(widget: widget, to: self, with: context)
    }

}
