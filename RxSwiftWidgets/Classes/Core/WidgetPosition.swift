//
//  WidgetPosition.swift
//  Widgets
//
//  Created by Michael Long on 3/22/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public enum WidgetAlignmentHorizontal {
    case left
    case right
    case leading
    case trailing
    case fill
    case center
}

public enum WidgetAlignmentVertical {
    case top
    case bottom
    case baseline
    case fill
    case center
}

public typealias WidgetPositionBlock = (_ view: UIView, _ padding: WidgetPadding) -> Void

public protocol WidgetPositioningSupported: class {
    var position: WidgetPosition? { get set }
    func position(_ position: WidgetPosition) -> Self
}

public extension WidgetPositioningSupported {
    func position(_ position: WidgetPosition) -> Self {
        self.position = position
        return self
    }
}

public enum WidgetPosition {

    case top
    case bottom
    case left
    case right

    case center

    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    case fill

//    case fillLeft
//    case fillRight
//    case fillTop
//    case fillBottom

    case custom(WidgetPositionBlock)

    public func constrain(parent: UIView, child: UIView, with padding: WidgetPadding) {
        switch self {
        case .top:
            addConstraints(h: .fill, v: .top, to: parent, child, with: padding)
        case .bottom:
            addConstraints(h: .fill, v: .bottom, to: parent, child, with: padding)
        case .left:
            addConstraints(h: .left, v: .fill, to: parent, child, with: padding)
        case .right:
            addConstraints(h: .right, v: .fill, to: parent, child, with: padding)
        case .center:
            addConstraints(h: .center, v: .fill, to: parent, child, with: padding)
        case .topLeft:
            addConstraints(h: .left, v: .top, to: parent, child, with: padding)
        case .topRight:
            addConstraints(h: .right, v: .top, to: parent, child, with: padding)
        case .bottomLeft:
            addConstraints(h: .left, v: .bottom, to: parent, child, with: padding)
        case .bottomRight:
            addConstraints(h: .right, v: .bottom, to: parent, child, with: padding)
        case .fill:
            addConstraints(h: .fill, v: .fill, to: parent, child, with: padding)
//        case .fillLeft:
//            addConstraints(h: .left, v: .fill, to: parent, child, with: padding)
//        case .fillRight:
//            addConstraints(h: .right, v: .fill, to: parent, child, with: padding)
//        case .fillTop:
//            addConstraints(h: .fill, v: .top, to: parent, child, with: padding)
//        case .fillBottom:
//            addConstraints(h: .fill, v: .bottom, to: parent, child, with: padding)
        case .custom(let custom):
            custom(child, padding)
        }
    }

    public func addConstraints(h: WidgetAlignmentHorizontal, v: WidgetAlignmentVertical, to parent: UIView, _ child: UIView, with padding: WidgetPadding) {
        addConstraints(h: h, to: parent, child, with: padding)
        addConstraints(v: v, to: parent, child, with: padding)
    }

    public func addConstraints(h: WidgetAlignmentHorizontal, to parent: UIView, _ child: UIView, with padding: WidgetPadding) {
        var constraints: [NSLayoutConstraint]!

        switch h {
        case .left:
            constraints = [
                child.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: padding.left),
                child.rightAnchor.constraint(lessThanOrEqualTo: parent.rightAnchor, constant: -padding.right),
            ]
        case .right:
            constraints = [
                child.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor, constant: padding.left),
                child.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -padding.right),
                ]
        case .leading:
            constraints = [
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: padding.left),
                child.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor, constant: -padding.right),
                ]
        case .trailing:
            constraints = [
                child.trailingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor, constant: padding.left),
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -padding.right),
                ]
        case .center:
            constraints = [
                child.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor, constant: padding.left),
                child.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                child.rightAnchor.constraint(lessThanOrEqualTo: parent.rightAnchor, constant: -padding.right),
                ]
        default:
            constraints = [
                child.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: padding.left),
                child.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -padding.right),
                ]
        }

        constraints.forEach { $0.priority = UILayoutPriority(999) }
        NSLayoutConstraint.activate(constraints)
    }

    public func addConstraints(v: WidgetAlignmentVertical, to parent: UIView, _ child: UIView, with padding: WidgetPadding) {
        var constraints: [NSLayoutConstraint]!

        switch v {
        case .top:
            constraints = [
                child.topAnchor.constraint(equalTo: parent.topAnchor, constant: padding.top),
                child.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor, constant: -padding.bottom),
                ]
        case .bottom:
            constraints = [
                child.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor, constant: padding.top),
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -padding.bottom),
                ]
        case .center:
            constraints = [
                child.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor, constant: padding.top),
                child.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                child.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor, constant: -padding.bottom),
                ]
        default:
            constraints = [
                child.topAnchor.constraint(equalTo: parent.topAnchor, constant: padding.top),
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -padding.bottom),
                ]
        }

        constraints.forEach { $0.priority = UILayoutPriority(999) }
        NSLayoutConstraint.activate(constraints)
    }

}


extension WidgetPosition {
    static public var dummy: WidgetPosition {
        return .custom({ (view, context) in
            // sampe
        })
    }
}
