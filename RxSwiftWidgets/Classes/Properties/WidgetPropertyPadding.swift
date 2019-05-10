//
//  WidgetPropertyPadding.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - Padding

public typealias WidgetPadding = UIEdgeInsets

public protocol WidgetPropertyPaddingSupported: class {
    var padding: WidgetPadding? { get set }
    func padding(_ padding: WidgetPadding) -> Self
    func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self
    func padding(h: CGFloat, v: CGFloat) -> Self
    func padding(_ padding: CGFloat) -> Self
}

public extension WidgetPropertyPaddingSupported where Self : Widget {
    func padding(_ padding: WidgetPadding) -> Self {
        self.padding = padding
        return self
    }
    func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        self.padding = WidgetPadding(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    func padding(h: CGFloat, v: CGFloat) -> Self {
        self.padding = WidgetPadding(top: v, left: h, bottom: v, right: h)
        return self
    }
    func padding(_ padding: CGFloat) -> Self {
        self.padding = WidgetPadding(top: padding, left: padding, bottom: padding, right: padding)
        return self
    }
}
