//
//  WidgetPropertyTextColor.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - TextColor

public struct WidgetPropertyTextColor: WidgetProperty {
    static public var key = "WidgetPropertyTextColor"
    public var color: UIColor
    public init(color: UIColor) {
        self.color = color
    }
}

public protocol WidgetPropertyTextColorSupported {
    func text(color: UIColor) -> Self
}

public extension WidgetPropertyTextColorSupported where Self : Widget {
    func text(color: UIColor) -> Self {
        setProperty(WidgetPropertyTextColor(color: color))
        return self
    }
}
