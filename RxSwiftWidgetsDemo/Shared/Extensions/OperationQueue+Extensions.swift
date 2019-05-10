//
//  OperationQueue+Extensions.swift
//  AuthenticationTest
//
//  Created by Michael Long on 3/8/17.
//  Copyright © 2017 com.hmlong. All rights reserved.
//

import UIKit

extension OperationQueue {

    public static let background = OperationQueue(qualityOfService: .background)

    public convenience init(qualityOfService: QualityOfService) {
        self.init()
        self.qualityOfService = qualityOfService
    }
    
}
