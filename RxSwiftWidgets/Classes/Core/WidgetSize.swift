//
//  WidgetSize.swift
//  Widgets
//
//  Created by Michael Long on 3/22/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public typealias WidgetSizeBlock = (_ view: UIView) -> Void

public protocol WidgetSizingSupported: class {
    var height: WidgetHeight? { get set }
    var width: WidgetWidth? { get set }

    func height(_ height: CGFloat) -> Self
    func height(min height: CGFloat) -> Self
    func height(max height: CGFloat) -> Self

    func width(_ width: CGFloat) -> Self
    func width(min width: CGFloat) -> Self
    func width(max width: CGFloat) -> Self
}

extension WidgetSizingSupported {
    public func height(_ height: CGFloat) -> Self {
        self.height = .height(height)
        return self
    }
    public func height(min height: CGFloat) -> Self {
        self.height = .minHeight(height)
        return self
    }
    public func height(max height: CGFloat) -> Self {
        self.height = .maxHeight(height)
        return self
    }

    public func width(_ width: CGFloat) -> Self {
        self.width = .width(width)
        return self
    }
    public func width(min width: CGFloat) -> Self {
        self.width = .minWidth(width)
        return self
    }
    public func width(max width: CGFloat) -> Self {
        self.width = .maxWidth(width)
        return self
    }
}

public enum WidgetHeight {

    case height(_ height: CGFloat)
    case maxHeight(_ height: CGFloat)
    case minHeight(_ height: CGFloat)
    case proportional(_ height: CGFloat)

    //    case aspectRatio(h: CGFloat, v: CGFloat)

    case custom(block: WidgetSizeBlock)

    public func applySize(to view: UIView) {

        switch self {

        case .height(let height):
            let constraint = view.heightAnchor.constraint(equalToConstant: height)
            constraint.priority = .defaultHigh
            constraint.isActive = true

        case .maxHeight(let height):
            let constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            constraint.priority = .defaultHigh
            constraint.isActive = true

        case .minHeight(let height):
            let constraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            constraint.priority = .defaultHigh
            constraint.isActive = true

        case .proportional(let height):
            if let view = view as? WidgetPrivateContainerView {
                view.proportionalHeight = height
            }

            //        case .aspectRatio(let h, let v):
            //            if h > v {
            //                let constraint = view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: h / v)
            //                constraint.priority = .defaultHigh
            //                constraint.isActive = true
            //            } else {
            //                let constraint = view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: v / h)
            //                constraint.priority = .defaultHigh
            //                constraint.isActive = true
            //            }

        case .custom(let block):
            block(view)

        }

    }

}

public enum WidgetWidth {

    case width(_ width: CGFloat)
    case maxWidth(_ width: CGFloat)
    case minWidth(_ width: CGFloat)
    case proportional(_ width: CGFloat)

    //    case aspectRatio(h: CGFloat, v: CGFloat)

    case custom(block: WidgetSizeBlock)

    public func applySize(to view: UIView) {

        switch self {

        case .width(let width):
            let constraint = view.widthAnchor.constraint(equalToConstant: width)
            constraint.priority = .defaultHigh
            constraint.isActive = true

        case .maxWidth(let width):
            let constraint = view.widthAnchor.constraint(lessThanOrEqualToConstant: width)
            constraint.priority = .defaultHigh
            constraint.isActive = true

        case .minWidth(let width):
            let constraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            constraint.priority = .defaultHigh
            constraint.isActive = true

        case .proportional(let width):
            if let view = view as? WidgetPrivateContainerView {
                view.proportionalWidth = width
            }

            //        case .aspectRatio(let h, let v):
            //            if h > v {
            //                let constraint = view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: h / v)
            //                constraint.priority = .defaultHigh
            //                constraint.isActive = true
            //            } else {
            //                let constraint = view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: v / h)
            //                constraint.priority = .defaultHigh
            //                constraint.isActive = true
            //            }

        case .custom(let block):
            block(view)

        }
    }

}
