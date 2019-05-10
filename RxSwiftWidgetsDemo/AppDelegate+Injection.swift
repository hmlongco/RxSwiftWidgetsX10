//
//  AppDelegate+Injection.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {

    static let session = ResolverScopeCache()

    // all registration functions need to be registered here
    public static func registerAllServices() {
        registerMain()
    }

}
