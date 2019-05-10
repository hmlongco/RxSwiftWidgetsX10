//
//  ContextWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class ContextWidget: WidgetBaseChildWrapper {

    private var properties = [WidgetProperty]()

    override open func setProperty(_ property: WidgetProperty) {
        // ensure nothing is set on view
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        var context = context

        for property in properties {
            context.setProperty(property)
        }

        return child?.build(context)
    }


    override open func set(_ property: WidgetProperty) -> Self {
        properties += [property]
        return self
    }

}
