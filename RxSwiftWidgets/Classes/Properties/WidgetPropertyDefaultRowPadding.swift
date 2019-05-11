//
//  WidgetPropertyDefaultRowPadding.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - Padding

public struct WidgetPropertyDefaultRowPadding: WidgetProperty {
    static public var key = "WidgetPropertyDefaultRowPadding"
    public var padding: WidgetPadding
    public init(padding: WidgetPadding) {
        self.padding = padding
    }
}

public protocol WidgetPropertyDefaultRowPaddingSupported {
    func defaultRowPadding(_ padding: WidgetPadding) -> Self
    func defaultRowPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self
    func defaultRowPadding(h: CGFloat, v: CGFloat) -> Self
    func defaultRowPadding(_ padding: CGFloat) -> Self
}

public extension WidgetPropertyDefaultRowPaddingSupported where Self : Widget {
    func defaultRowPadding(_ padding: WidgetPadding) -> Self {
        setProperty(WidgetPropertyDefaultRowPadding(padding: padding))
        return self
    }
    func defaultRowPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        setProperty(WidgetPropertyDefaultRowPadding(padding: WidgetPadding(top: top, left: left, bottom: bottom, right: right)))
        return self
    }
    func defaultRowPadding(h: CGFloat, v: CGFloat) -> Self {
        setProperty(WidgetPropertyDefaultRowPadding(padding: WidgetPadding(top: v, left: h, bottom: v, right: h)))
        return self
    }
    func defaultRowPadding(_ padding: CGFloat) -> Self {
        setProperty(WidgetPropertyDefaultRowPadding(padding: WidgetPadding(top: padding, left: padding, bottom: padding, right: padding)))
        return self
    }
}
