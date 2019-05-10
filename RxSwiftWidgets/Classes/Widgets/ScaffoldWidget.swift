//
//  ScaffoldWidget
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class ScaffoldWidget: WidgetBase<UIView>, WidgetChildManaging {

    var background: Widget?
    var header: Widget?
    var footer: Widget?

    var backgroundImage: UIImage?
    var backgroundImageView: UIImageView?

    required public init(_ child: Widget) {
        super.init()
        self.children = [child]
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        return UIView()
    }

    override open func applyProperties(to view: UIView, with context: WidgetContext) {

        view.backgroundColor = .clear

        super.applyProperties(to: view, with: context)

        if let backgroundImage = backgroundImage {
            backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(backgroundImageView!)
        }

        if let backgroundView = background?.build(context) {
            view.addSubview(backgroundView)
        }

        if let subview = child?.build(context) {
            view.addSubview(subview)
            child?.viewAddedToSuperview()
        }

        if let subview = header?.build(context) {
            view.addSubview(subview)
            header?.viewAddedToSuperview()
        }

        if let subview = footer?.build(context) {
            view.addSubview(subview)
            footer?.viewAddedToSuperview()
        }
    }

    override open func apply(property: WidgetProperty, with context: WidgetContext) {
        switch property {

        case let property as WidgetPropertyBackgroundImage:
            self.backgroundImage = property.image

        default:
            super.apply(property: property, with: context)
        }
    }

    override open func applyConstraints() {
        guard let scaffold = view else { return }

        var constraints: [NSLayoutConstraint] = []

        if let imageView = backgroundImageView {
            constraints += [
                imageView.leftAnchor.constraint(equalTo: scaffold.leftAnchor),
                imageView.rightAnchor.constraint(equalTo: scaffold.rightAnchor),
                imageView.topAnchor.constraint(equalTo: scaffold.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scaffold.bottomAnchor),
            ]
        }

        if let backgroundView = background?.view {
            constraints += [
                backgroundView.leftAnchor.constraint(equalTo: scaffold.leftAnchor),
                backgroundView.rightAnchor.constraint(equalTo: scaffold.rightAnchor),
                backgroundView.topAnchor.constraint(equalTo: scaffold.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: scaffold.bottomAnchor),
            ]
        }

        guard let body = child?.view else { return }

        constraints += [
            body.leftAnchor.constraint(equalTo: scaffold.leftAnchor),
            body.rightAnchor.constraint(equalTo: scaffold.rightAnchor),
        ]

        if let header = header?.view {
            constraints += [
                header.leftAnchor.constraint(equalTo: scaffold.leftAnchor),
                header.rightAnchor.constraint(equalTo: scaffold.rightAnchor),
                header.topAnchor.constraint(equalTo: scaffold.topAnchor),
                body.topAnchor.constraint(equalTo: header.bottomAnchor),
            ]
            header.setContentHuggingPriority(.required, for: .vertical)
        } else {
            constraints += [
                body.topAnchor.constraint(equalTo: scaffold.topAnchor),
            ]
        }

        if let footer = footer?.view {
            constraints += [
                body.bottomAnchor.constraint(equalTo: footer.topAnchor),
                footer.leftAnchor.constraint(equalTo: scaffold.leftAnchor),
                footer.rightAnchor.constraint(equalTo: scaffold.rightAnchor),
                footer.bottomAnchor.constraint(equalTo: scaffold.bottomAnchor)
            ]
            footer.setContentHuggingPriority(.required, for: .vertical)
        } else {
            constraints += [
                body.bottomAnchor.constraint(equalTo: scaffold.bottomAnchor),
            ]
        }

        for constraint in constraints {
            constraint.priority = .required
        }

        NSLayoutConstraint.activate(constraints)
    }

    public func background(_ widget: Widget) -> Self {
        self.background = widget
        return self
    }

    public func header(_ widget: Widget) -> Self {
        self.header = widget
        return self
    }

    public func footer(_ widget: Widget) -> Self {
        self.footer = widget
        return self
    }

}

extension ScaffoldWidget:
    WidgetPropertyBackgroundImageSupported
    {}
