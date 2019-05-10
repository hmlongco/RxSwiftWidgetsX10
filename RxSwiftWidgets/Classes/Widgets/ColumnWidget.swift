//
//  ColumnWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

// Note most of the heavy lifting is done by WidgetBaseContainer

open class ColumnWidget: WidgetBase<UIStackView>, WidgetChildrenManaging {

    internal var distribution = UIStackView.Distribution.fill
    internal var spacing: CGFloat = 8
    internal var horizontalAlignment: WidgetAlignmentHorizontal = .fill

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
        stack.axis = .vertical
        stack.distribution = distribution
        stack.spacing = spacing

        switch horizontalAlignment {
        case .left, .leading:
            stack.alignment = .leading
        case .right, .trailing:
            stack.alignment = .trailing
        case .fill:
            stack.alignment = .fill
        case .center:
            stack.alignment = .center
        }

        var context = context
        if let defaultRowPadding = WidgetPropertyDefaultRowPadding.from(self) {
            context.setProperty(defaultRowPadding)
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

    public func align(horizontal: WidgetAlignmentHorizontal) -> Self {
        self.horizontalAlignment = horizontal
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

internal class WidgetPrivateStackView: UIStackView {

    var disposeBag: DisposeBag!

    public func subscribe(to builder: AnyObservableListBuilder, with context: WidgetContext) {
        builder.items
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (items) in

                self.disposeBag = DisposeBag()
                var context = context
                context.disposeBag = self.disposeBag

                self.subviews.forEach {
                    $0.removeFromSuperview()
                }

                items.forEach {
                    if let widget = builder.widget(for: $0), let view = widget.build(context) {
                        self.addArrangedSubview(view)
                        widget.viewAddedToSuperview()
                    }
                }

                UIView.animate(withDuration: 0.01, animations: {
                    self.layoutIfNeeded()
                })
            })
            .disposed(by: context.disposeBag)
    }

}


extension ColumnWidget:
    WidgetPropertyPaddingSupported,
    WidgetPropertyDefaultRowPaddingSupported
    {}
