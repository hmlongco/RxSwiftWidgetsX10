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

open class FormTextField: FormField {

    public func initialValue(_ value: String?) -> Self {
        text = value
        return self
    }

    override public var isValid: Bool {
        guard self.required > 0 else {
            return true
        }
        if let text = text, text.count >= self.required {
            return true
        }
        return false
    }

    public func required(min: Int = 1) -> Self {
        required = min
        return self
    }

    override public var text: String? {
        get { return state.value }
        set { state.accept(newValue) }
    }

    public func textObservable() -> Observable<String?> {
        return state.asObservable()
    }

    public func text(bind observable: Observable<String?>) -> Disposable {
        return observable.bind(to: state)
    }

    internal var required: Int = 0
    internal var state = BehaviorRelay<String?>(value: nil)
}
