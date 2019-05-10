//
//  RowWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

// Note most of the heavy lifting is done by WidgetBaseContainer

open class RowWidget: WidgetBase<UIStackView>, WidgetChildrenManaging {

    internal var distribution = UIStackView.Distribution.fill
    internal var spacing: CGFloat = 8
    internal var verticalAlignment: WidgetAlignmentVertical = .fill

    internal var builder: AnyObservableListBuilder?

    required public init(_ children: [Widget]) {
        super.init()
        self.children = children
        if #available(iOS 11.0, *) {
            self.spacing = UIStackView.spacingUseSystem
        }
    }

    override open func buildInitialView(with context: WidgetContext) -> UIStackView? {
        return WidgetPrivateStackView()
    }

    override open func applyProperties(to view: UIStackView, with context: WidgetContext) {
        guard let stack = view as? WidgetPrivateStackView else { return }

        super.applyProperties(to: view, with: context)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = distribution
        stack.spacing = spacing

        switch verticalAlignment {
        case .top:
            stack.alignment = .top
        case .bottom:
            stack.alignment = .bottom
        case .fill:
            stack.alignment = .fill
        case .center:
            stack.alignment = .center
        case .baseline:
            stack.alignment = .firstBaseline
        }

        // very special case for column WidgetPropertyDefaultRowPadding translating to row WidgetPropertyPadding
        var context = context
        if let defaultRowPadding = WidgetPropertyDefaultRowPadding.from(context) {
            context.removeProperty(WidgetPropertyDefaultRowPadding.key) // children won't see it
            if padding == nil {
                padding = defaultRowPadding.padding
            }
        }

        if let padding = padding {
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = padding
        }

        children.forEach { child in
            if let view = child.build(context) {
                stack.addArrangedSubview(view)
                child.viewAddedToSuperview()
            }
        }

        if let builder = builder {
            stack.subscribe(to: builder, with: context)
        }
    }

    public func align(vertical: WidgetAlignmentVertical) -> Self {
        self.verticalAlignment = vertical
        return self
    }

    public func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    public func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    public func contents<Item>(bind builder: ObservableListBuilder<Item>) -> Self {
        self.builder = AnyObservableListBuilder(builder)
        return self
    }

    public func contents(bind observable: Observable<[Widget]>) -> Self {
        self.builder = AnyObservableListBuilder(ObservableListBuilder(observable) { $0 })
        return self
    }

}

extension RowWidget:
    WidgetPropertyPaddingSupported
    {}
