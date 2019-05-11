//
//  WidgetPropertyHidden.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - Hidden

public struct WidgetPropertyHidden: WidgetPropertyApplying {
    static public var key = String(describing: WidgetPropertyHidden.self)
    public var hidden: Bool
    public init(hidden: Bool) {
        self.hidden = hidden
    }
    public func apply(to widget: Widget, with context: WidgetContext) {
        guard let view = widget.view else { return }
        view.isHidden = hidden
    }
}

public protocol WidgetPropertyHiddenSupported: Widget {
    func hidden(_ hidden: Bool) -> Self
}

public extension WidgetPropertyHiddenSupported where Self : Widget {
    func hidden(_ hidden: Bool) -> Self {
        setProperty(WidgetPropertyHidden(hidden: hidden))
        return self
    }
}

// Widget Property - Hidden Binding

public struct WidgetPropertyHiddenBinding: WidgetPropertyApplying {
    static public var key = String(describing: WidgetPropertyHiddenBinding.self)
    public var observable: Observable<Bool>
    public func apply(to widget: Widget, with context: WidgetContext) {
        guard let view = widget.view else { return }
        observable.bind(to: view.rx.isHidden).disposed(by: context.disposeBag)
    }
}

public protocol WidgetPropertyHiddenBindingSupported: Widget {
    func hidden(bind observable: Observable<Bool>) -> Self
}

public extension WidgetPropertyHiddenBindingSupported where Self : Widget {
    func hidden(bind observable: Observable<Bool>) -> Self {
        setProperty(WidgetPropertyHiddenBinding(observable: observable))
        return self
    }
}

extension WidgetBase:
    WidgetPropertyHiddenSupported,
    WidgetPropertyHiddenBindingSupported
    {}
