//
//  UIView+Extensions.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

extension UIView {

    func fillSuperviewWidth() {
        superview?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        superview?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    func fillSuperviewHeight() {
        superview?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        superview?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func fillSuperview() {
        fillSuperviewWidth()
        fillSuperviewHeight()
    }

}

enum ConstraintHorizontalAxisMode {
    case none
    case leading
    case trailing
    case fill
    case center
}

enum ContstraintVertialAxisMode {
    case none
    case top
    case bottom
    case fill
    case center
}

extension UIView {

    func constrain(subview: UIView, hAxis: ConstraintHorizontalAxisMode = .fill, vAxis: ContstraintVertialAxisMode = .fill) {
        switch hAxis {
        case .none:
            break
        case .leading:
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            subview.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        case .trailing:
            subview.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        case .fill:
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        case .center:
            subview.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
            subview.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            subview.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        }

        switch vAxis {
        case .none:
            break
        case .top:
            subview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subview.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true
        case .bottom:
            subview.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        case .fill:
            subview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        case .center:
            subview.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
            subview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            subview.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true
        }
   }

}
