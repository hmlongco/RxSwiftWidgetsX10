//
//  Main+Injection.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerMain() {
        register { MainCoordinator() }
        register { MainViewModel() }
    }
}
