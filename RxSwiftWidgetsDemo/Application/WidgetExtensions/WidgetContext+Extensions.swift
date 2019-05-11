//
//  WidgetContext+Extensions.swift
//  Widgets
//
//  Created by Michael Long on 3/6/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftWidgets

public extension WidgetContext {

    // MARK: - Lifecycle

    static func defaultContext() -> WidgetContext {
        var context = WidgetContext()

        context.setProperty(WidgetPropertyTextFont(font: Style.shared.textFont))
        context.setProperty(WidgetPropertyTextColor(color: Style.shared.textColor))

        return context
    }
    
}
