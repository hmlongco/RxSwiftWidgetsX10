//
//  WidgetPropertyAlpha.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - Alpha

public struct WidgetPropertyAlpha: WidgetPropertyApplying {
    static public var key = "WidgetPropertyAlpha"
    public var alpha: CGFloat
    public func apply(to widget: Widget, with context: WidgetContext) {
        guard let view = widget.view else { return }
        view.alpha = alpha
    }
}

public protocol WidgetPropertyAlphaSupported {
    func alpha(_ alpha: CGFloat) -> Self
}

public extension WidgetPropertyAlphaSupported where Self : Widget {
    func alpha(_ alpha: CGFloat) -> Self {
        setProperty(WidgetPropertyAlpha(alpha: alpha))
        return self
    }
}

extension WidgetBase: WidgetPropertyAlphaSupported {}
