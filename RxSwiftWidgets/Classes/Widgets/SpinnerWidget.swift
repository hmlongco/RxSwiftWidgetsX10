//
//  SpinnerWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class SpinnerWidget: WidgetBase<UIActivityIndicatorView> {

    var color: UIColor = .gray

    override public init() {
        super.init()
    }

    override open func buildInitialView(with context: WidgetContext) -> UIActivityIndicatorView? {
        let view = UIActivityIndicatorView(frame: .zero)
        view.color = color
        return view
    }

    override open func viewAddedToSuperview() {
        super.viewAddedToSuperview()
        (view as? UIActivityIndicatorView)?.startAnimating()
    }

    public func color(_ color: UIColor) -> Self {
        self.color = color
        return self
    }

}
