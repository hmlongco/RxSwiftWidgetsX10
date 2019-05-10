//
//  LabelWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class LabelWidget: WidgetBase<UILabel> {

    internal var numberOfLines: Int = 1
    internal var hidesWhenEmpty = false
    internal var hidesWhenEmptyObservable: Observable<Bool>?

    override open func buildInitialView(with context: WidgetContext) -> UILabel {
        let view = WidgetPrivateLabel()
        view.backgroundColor = .clear
        return view
    }

    override open func applyProperties(to view: UILabel, with context: WidgetContext) {
        guard let label = view as? WidgetPrivateLabel else { return }

        label.numberOfLines = numberOfLines
        if numberOfLines == 0 {
            label.lineBreakMode = .byWordWrapping
            label.setContentCompressionResistancePriority(.required, for: .vertical)
        }

        super.applyProperties(to: view, with: context)

        label.padding = padding ?? .zero

        if hidesWhenEmpty {
            label.isHidden = label.text?.isEmpty ?? true
            hidesWhenEmptyObservable?.bind(to: label.rx.isHidden).disposed(by: context.disposeBag)
       }
   }

    override open func apply(property: WidgetProperty, with context: WidgetContext) {
        guard let label = view as? WidgetPrivateLabel else { return }

        switch property {

        case let property as WidgetPropertyText:
            label.text = property.text

        case let property as WidgetPropertyTextAlign:
            label.textAlignment = property.alignment

        case let property as WidgetPropertyTextBinding:
            property.observable.bind(to: label.rx.text).disposed(by: context.disposeBag)
            hidesWhenEmptyObservable = property.observable.map { $0.isEmpty }

        case let property as WidgetPropertyOptionalTextBinding:
            property.observable.bind(to: label.rx.text).disposed(by: context.disposeBag)
            hidesWhenEmptyObservable = property.observable.map { $0?.isEmpty ?? true }

        case let property as WidgetPropertyTextColor:
            label.textColor = property.color

        case let property as WidgetPropertyTextFont:
            label.font = property.font

        default:
            super.apply(property: property, with: context)
        }
    }

    public func onEmptyHide() -> Self {
        self.hidesWhenEmpty = true
        return self
    }

    public func numberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }

}

internal class WidgetPrivateLabel : UILabel {

    var padding = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: padding)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        guard text != nil else { return textRect }
        let invertedRecr = UIEdgeInsets(top: -padding.top, left: -padding.left, bottom: -padding.bottom, right: -padding.right)
        return textRect.inset(by: invertedRecr)
    }

    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

}

extension LabelWidget:
    WidgetPropertyPaddingSupported,
    WidgetPropertyTextSupported,
    WidgetPropertyTextAlignSupported,
    WidgetPropertyTextBindingSupported,
    WidgetPropertyOptionalTextBindingSupported,
    WidgetPropertyTextColorSupported,
    WidgetPropertyTextFontSupported
    {}
