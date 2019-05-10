//
//  WidgetPropertyTextFont.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - TextFont

public struct WidgetPropertyTextFont: WidgetProperty {
    static public var key = "WidgetPropertyTextFont"
    public var font: UIFont
}

public protocol WidgetPropertyTextFontSupported {
    func text(font: UIFont) -> Self
}

public extension WidgetPropertyTextFontSupported where Self : Widget {
     func text(font: UIFont) -> Self {
        setProperty(WidgetPropertyTextFont(font: font))
        return self
    }
}
