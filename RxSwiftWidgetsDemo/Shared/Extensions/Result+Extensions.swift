//
//  Result+Extensions.swift
//
//  Created by Michael Long on 4/2/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation

public extension Swift.Result where Failure : Error {

    private enum NoFailureError: Error {
        case error
    }

    func error() throws -> Failure {
        if case let .failure(failure) = self {
            return failure
        }
        throw NoFailureError.error
    }

}
