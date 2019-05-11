//
//  SeparatorWidget
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class SeparatorWidget: WidgetBase<UIView> {

    override public init() {
        super.init()
        _ = height(0.5)
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 0.5))
    }

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        super.applyProperties(to: view, with: context)
        view.backgroundColor = .lightGray
    }

}
