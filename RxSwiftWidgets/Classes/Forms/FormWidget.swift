
//
//  FormWidget.swift
//  Widgets
//
//  Created by Michael Long on 5/1/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


open class FormWidget: WidgetBaseChildWrapper, WidgetPropertyFormFieldListSupported {

    public var fields: FormFields?

    override open func newContext(from context: WidgetContext) -> WidgetContext {
        var context = super.newContext(from: context)
        if let fields = WidgetPropertyFormFieldList.from(self)?.fields {
            context.setProperty(WidgetPropertyFormFieldList(fields: fields))
        }
        return context
    }

}

public struct WidgetPropertyFormFieldList: WidgetProperty {
    static public var key = "WidgetPropertyFormFieldList"
    public var fields: FormFields
}

public protocol WidgetPropertyFormFieldListSupported {
    var fields: FormFields? { get }
    func fields(_ fields: FormFields) -> Self
}

public extension WidgetPropertyFormFieldListSupported where Self : Widget {
    func fields(_ fields: FormFields) -> Self {
        setProperty(WidgetPropertyFormFieldList(fields: fields))
        return self
    }
}
