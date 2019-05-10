//
//  ViewWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class ViewWidget<View:UIView>: WidgetBase<View> {

    internal var builder: ((_ context: WidgetContext) -> UIView)?

    override open func buildInitialView(with context: WidgetContext) -> View? {
        return builder?(context) as? View
    }
    
    public func viewBuilder(_ builder: @escaping (_ context: WidgetContext) -> UIView) -> Self {
        self.builder = builder
        return self
    }

}
