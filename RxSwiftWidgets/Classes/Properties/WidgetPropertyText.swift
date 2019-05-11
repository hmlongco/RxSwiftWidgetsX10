//
//  WidgetPropertyText.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - Text

public struct WidgetPropertyText: WidgetProperty {
    static public var key: String = "WidgetPropertyText"
    public var text: String?
    public init(text: String?) {
        self.text = text
    }
}

public protocol WidgetPropertyTextSupported {
    func text(_ text: String?) -> Self
}

public extension WidgetPropertyTextSupported where Self : Widget {
    func text(_ text: String?) -> Self {
        setProperty(WidgetPropertyText(text: text))
        return self
    }
}

// Widget Property - Text Binding

public struct WidgetPropertyTextBinding: WidgetProperty {
    static public var key: String = "WidgetPropertyTextBinding"
    public var observable: Observable<String>
    public init(observable: Observable<String>) {
        self.observable = observable
    }
}

public protocol WidgetPropertyTextBindingSupported {
    func text(bind observable: Observable<String>) -> Self
}

public extension WidgetPropertyTextBindingSupported where Self : Widget {
    func text(bind observable: Observable<String>) -> Self {
        setProperty(WidgetPropertyTextBinding(observable: observable))
        return self
    }
}

public struct WidgetPropertyOptionalTextBinding: WidgetProperty {
    static public var key: String = "WidgetPropertyOptionalTextBinding"
    public var observable: Observable<String?>
    public init(observable: Observable<String?>) {
        self.observable = observable
    }
}

public protocol WidgetPropertyOptionalTextBindingSupported {
    func text(bind observable: Observable<String?>) -> Self
}

public extension WidgetPropertyOptionalTextBindingSupported where Self : Widget {
    func text(bind observable: Observable<String?>) -> Self {
        setProperty(WidgetPropertyOptionalTextBinding(observable: observable))
        return self
    }
}

