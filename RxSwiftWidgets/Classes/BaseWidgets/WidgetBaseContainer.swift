//
//  WidgetBaseContainer.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class WidgetBaseContainer<View:UIView>: WidgetBase<View> {

    override public init() {
        super.init()
        self.position = .fill
        self.padding = .zero
    }

}

extension WidgetBaseContainer:
    WidgetPropertyPaddingSupported,
    WidgetPositioningSupported
    {}
