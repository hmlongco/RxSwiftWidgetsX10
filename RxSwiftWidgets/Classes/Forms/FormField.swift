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

open class FormField: FormValidating {
    
    public var id = 0
    public var name: String?

    init(_ id: Int = 0) {
        self.id = id
    }

    convenience init<T>(_ id: T) where T: RawRepresentable, T.RawValue == Int {
        self.init(id.rawValue)
        self.name = "\(id)"
    }

    public var isValid: Bool { return true }

    // everything should be expressable as text

    public var text: String? {
        get { return nil }
        set {  }
    }

}
