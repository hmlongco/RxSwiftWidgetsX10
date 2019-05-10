//
//  FormField.swift
//  Widgets
//
//  Created by Michael Long on 5/1/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol FormValidating {
    var isValid: Bool { get }
}
