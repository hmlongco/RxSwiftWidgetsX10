//
//  WidgetProperties.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift


public protocol WidgetProperty {
    static var key: String { get }
    static func from(_ provider: WidgetPropertyProviding) -> Self?
}

public extension WidgetProperty {
    static func from(_ provider: WidgetPropertyProviding) -> Self? {
        return provider.getProperty(key) as? Self
    }
}


public protocol WidgetPropertyApplying: WidgetProperty {
    func apply(to widget: Widget, with context: WidgetContext)
}


public protocol WidgetPropertyProviding {
    func getProperty(_ key: String) -> WidgetProperty?
}

public typealias WidgetPropertyBag = Dictionary<String, WidgetProperty>
