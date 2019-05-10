//
//  WidgetContext.swift
//  Widgets
//
//  Created by Michael Long on 3/3/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

public struct WidgetContext: WidgetPropertyProviding {

    public var parent: WidgetContextBox?

    public var currentWidget: Widget?

    public var propertyBag = WidgetPropertyBag()

    public var disposeBag = DisposeBag()

    public func newContext(for widget: Widget) -> WidgetContext {
        var context = self
        context.parent = WidgetContextBox(self)
        context.currentWidget = widget
        return context
    }

    public func hasProperty(_ key: String) -> Bool {
        return propertyBag[key] != nil
    }

    public func getProperty(_ key: String) -> WidgetProperty? {
        return propertyBag[key]
    }

    mutating public func removeProperty(_ key: String) {
        propertyBag.removeValue(forKey: key)
    }

    mutating public func setProperty(_ property: WidgetProperty) {
        propertyBag[type(of: property).key] = property
    }

}

open class WidgetContextBox {

    private let _context: WidgetContext

    init(_ context: WidgetContext) {
        self._context = context
    }

    var context: WidgetContext {
        return _context
    }

    var propertyBag: WidgetPropertyBag {
        return _context.propertyBag
    }

    var widget: Widget? {
        return _context.currentWidget
    }

}
