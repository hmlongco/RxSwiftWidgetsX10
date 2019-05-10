//
//  PlaceholderWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class PlaceholderWidget: WidgetBase<UIView> {

    override open func buildInitialView(with context: WidgetContext) -> UIView {
        return UIView()
    }

}
