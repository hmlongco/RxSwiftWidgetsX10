//
//  TextFieldWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class TextFieldWidget: WidgetBase<UITextField> {

    internal var changed: ((String?) -> Void)?
    internal var placeholder: String?

    override open func buildInitialView(with context: WidgetContext) -> UITextField {
        let view = WidgetPrivateTextField()
        view.backgroundColor = .clear
        return view
    }

    override open func applyProperties(to view: UITextField, with context: WidgetContext) {
        guard let textField = view as? WidgetPrivateTextField else { return }

        super.applyProperties(to: view, with: context)

        textField.placeholder = placeholder

        if let changed = changed {
            textField.rx.text
                .subscribe(onNext: { [changed] (text) in
                    changed(text)
                })
                .disposed(by: context.disposeBag)
        }
    }

    override open func apply(property: WidgetProperty, with context: WidgetContext) {
        guard let label = view as? UITextField else { return }

        switch property {

        case let property as WidgetPropertyText:
            label.text = property.text

        case let property as WidgetPropertyTextAlign:
            label.textAlignment = property.alignment

        case let property as WidgetPropertyTextBinding:
            property.observable.bind(to: label.rx.text).disposed(by: context.disposeBag)

        case let property as WidgetPropertyOptionalTextBinding:
            property.observable.bind(to: label.rx.text).disposed(by: context.disposeBag)

        case let property as WidgetPropertyTextColor:
            label.textColor = property.color

        case let property as WidgetPropertyTextFont:
            label.font = property.font

        default:
            super.apply(property: property, with: context)
        }
    }

    public func placeholder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }

    public func onTextChanged(_ changed: @escaping (String?) -> Void) -> Self {
        self.changed = changed
        return self
    }

}

open class WidgetPrivateTextField: UITextField {

    var disposeBag: DisposeBag!

    public func subscribe(to observable: Observable<Widget>, with context: WidgetContext) {

    }

}

extension TextFieldWidget:
    WidgetPropertyTextSupported,
    WidgetPropertyTextAlignSupported,
    WidgetPropertyTextBindingSupported,
    WidgetPropertyOptionalTextBindingSupported,
    WidgetPropertyTextColorSupported,
    WidgetPropertyTextFontSupported
    {}
