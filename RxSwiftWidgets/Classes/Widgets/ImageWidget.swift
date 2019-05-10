//
//  ImageWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class ImageWidget: WidgetBase<UIImageView> {

    override open func buildInitialView(with context: WidgetContext) -> UIImageView {
        return UIImageView()
    }

    override open func applyProperties(to view: UIImageView, with context: WidgetContext) {
        view.backgroundColor = .clear
        super.applyProperties(to: view, with: context)
    }
    
}

extension ImageWidget:
    WidgetPropertyImageSupported,
    WidgetPropertyImageNamedSupported,
    WidgetPropertyImageBindingSupported
{}
