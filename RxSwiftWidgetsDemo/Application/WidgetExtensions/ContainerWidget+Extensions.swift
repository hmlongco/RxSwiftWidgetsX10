//
//  ContainerWidget+Extensions.swift
//  Widgets
//
//  Created by Michael Long on 3/6/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

extension ContainerWidget {
    public static func section(_ child: Widget) -> ContainerWidget {
        return ContainerWidget(child)
            .backgroundColor(Style.shared.sectionBackgroundColor)
            .clipRadius(15)
            .padding(15)
    }
}
