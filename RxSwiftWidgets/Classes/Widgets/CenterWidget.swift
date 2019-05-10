//
//  CenterWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class CenterWidget: ContainerWidget {

    required public init(_ child: Widget) {
        super.init(child)
        self.position = WidgetPosition.center
    }

}
