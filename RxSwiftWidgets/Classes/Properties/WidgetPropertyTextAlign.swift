//
//  WidgetPropertyTextAlign.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - TextAlign

public struct WidgetPropertyTextAlign: WidgetProperty {
    static public var key: String = "WidgetPropertyTextAlign"
    public var alignment: NSTextAlignment
}

public protocol WidgetPropertyTextAlignSupported {
    func text(align: NSTextAlignment) -> Self
}

public extension WidgetPropertyTextAlignSupported where Self : Widget {
    func text(align: NSTextAlignment) -> Self {
        setProperty(WidgetPropertyTextAlign(alignment: align))
        return self
    }
}
