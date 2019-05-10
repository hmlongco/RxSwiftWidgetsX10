//
//  WidgetChildren.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Children

public protocol WidgetChildrenManaging: Widget {

    var children: [Widget] { get }

    init(_ children: [Widget])

}
