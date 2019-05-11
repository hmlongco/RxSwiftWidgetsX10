//
//  FormFields.swift
//  Widgets
//
//  Created by Michael Long on 5/1/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class FormFields: FormValidating {

    var list: [FormField]
    var lookup: [Int:FormField] = [:]

    public init(_ fields: FormField...) {
        list = fields
        fields.forEach { lookup[$0.id] = $0 }
    }

    open var isValid: Bool {
        return list.reduce(true, { $1.isValid && $0 })
    }

    public subscript(_ id: Int) -> FormField? {
        get { return lookup[id] }
    }

    public subscript<T>(_ id: T) -> FormField? where T: RawRepresentable, T.RawValue == Int {
        get { return lookup[id.rawValue] }
    }

}
