
//
//  FormTextFieldWidget.swift
//  Widgets
//
//  Created by Michael Long on 5/1/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

open class FormTextFieldWidget: TextFieldWidget {

    var formTextField: FormTextField?

    override open func applyProperties(to view: UITextField, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)

        if let formTextField = formTextField {
            bidirectionalBind(field: formTextField, view: view, context: context)
        }
    }

    override open func apply(property: WidgetProperty, with context: WidgetContext) {

        switch property {

        case let list as WidgetPropertyFormFieldList:
            guard id > 0 else { return }
            if let formTextField = list.fields[id] as? FormTextField {
                bidirectionalBind(field: formTextField, view: view, context: context)
            }

        default:
            super.apply(property: property, with: context)
        }

    }

    public func text(bind formTextField: FormTextField) -> Self {
        self.formTextField = formTextField
        return self
    }

    internal func bidirectionalBind(field: FormTextField, view: UIView?, context: WidgetContext) {
        guard let textField = view as? UITextField else { return }
        // bind field state to textfield
        field.textObservable().bind(to: textField.rx.text).disposed(by: context.disposeBag)
        // bind textfield changes back to field state
        field.text(bind: textField.rx.text.asObservable()).disposed(by: context.disposeBag)
    }
}
