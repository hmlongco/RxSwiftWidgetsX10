//
// Created by Jason Hanson on 9/7/17.
// Copyright (c) 2017 Client Resources Inc. All rights reserved.
//

import Foundation

extension DispatchQueue {

    public static var background = DispatchQueue(label: "background", qos: .background, attributes: .concurrent)

    open func delay(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }

}
