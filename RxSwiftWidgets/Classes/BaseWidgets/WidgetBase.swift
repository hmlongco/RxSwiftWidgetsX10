//
//  WidgetBase.swift
//  Widgets
//
//  Created by Michael Long on 3/8/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

open class WidgetBase<View:UIView>: Widget {

    public var id: Int = 0
    public var view: UIView?

    lazy public var children: [Widget] = []

    public var position: WidgetPosition?
    public var padding: WidgetPadding?
    public var height: WidgetHeight?
    public var width: WidgetWidth?

    public var with: ((_ view: View, _ context: WidgetContext) -> Void)?
    

    // MARK: - Property Management

    public var propertyBag = WidgetPropertyBag()

    open func getProperty(_ key: String) -> WidgetProperty? {
        return propertyBag[key]
    }

    open func setProperty(_ property: WidgetProperty) {
        propertyBag[type(of: property).key] = property
    }

    open func set(_ property: WidgetProperty) -> Self {
        propertyBag[type(of: property).key] = property
        return self
    }


    // MARK: - Widget Build Cycle

    open func newContext(from context: WidgetContext) -> WidgetContext {
        return context.newContext(for: self)
    }

    open func build(_ context: WidgetContext) -> UIView? {
        let context = newContext(from: context)
        if let view = buildInitialView(with: context) {
            applyProperties(to: view, with: context)
            with?(view, context)
            return view
        }
        return nil
    }


    // MARK: - View Build Cycle

    open func buildInitialView(with context: WidgetContext) -> View? {
        return nil
    }

    open func applyProperties(to view: View, with context: WidgetContext) {

        self.view = view

        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = id

        for (key, property) in context.propertyBag where getProperty(key) == nil {
            apply(property: property, with: context)
        }

        for (_, property) in propertyBag {
            apply(property: property, with: context)
        }
    }

    open func apply(property: WidgetProperty, with context: WidgetContext) {
        if let property = property as? WidgetPropertyApplying {
            property.apply(to: self, with: context)
        }
    }

    open func viewAddedToSuperview() {
        applyConstraints()
    }

    open func applyConstraints() {
        guard let view = view else { return }
        height?.applySize(to: view)
        width?.applySize(to: view)
        applyPosition()
    }

    open func applyPosition() {
        guard let view = view, let position = self.position else { return }
        view.subviews.forEach {
            position.constrain(parent: view, child: $0, with: padding ?? .zero)
        }
    }

    open func with(_ block: @escaping (_ view: View, _ context: WidgetContext) -> Void) -> Self {
        self.with = block
        return self
    }

}

extension WidgetBase: WidgetSizingSupported {
}
