//
//  WidgetPropertyBackgroundColor.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - BackgroundColor

public struct WidgetPropertyBackgroundColor: WidgetPropertyApplying {
    static public var key = "WidgetPropertyBackgroundColor"
    public var color: UIColor
    public init(color: UIColor) {
        self.color = color
    }
    public func apply(to widget: Widget, with context: WidgetContext) {
       widget.view?.backgroundColor = color
    }
}

public protocol WidgetPropertyBackgroundColorSupported {
    func backgroundColor(_ color: UIColor) -> Self
}

public extension WidgetPropertyBackgroundColorSupported where Self : Widget {
    func backgroundColor(_ color: UIColor) -> Self {
        setProperty(WidgetPropertyBackgroundColor(color: color))
        return self
    }
}

extension WidgetBase: WidgetPropertyBackgroundColorSupported {}
