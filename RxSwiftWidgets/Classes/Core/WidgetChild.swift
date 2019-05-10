//
//  WidgetChild.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Child

public protocol WidgetChildManaging: Widget {

    var child: Widget? { get }

    init(_ child: Widget)
    
}

public extension WidgetChildManaging {

    var child: Widget? { return children.first }

}
