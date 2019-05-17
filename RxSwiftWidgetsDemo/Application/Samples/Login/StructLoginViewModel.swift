//
//  LoginViewModel.swift
//  Widgets
//
//  Created by Michael Long on 3/31/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftWidgets

class StructLoginViewModel {

    // STATE

    enum Actions {
        case login
    }

    struct State {
        var authenticated: User?
        var error: String?
        var processing: Bool = false
        var helpString: String = "Contact Client Resources, Inc."
    }

    lazy var state = ObservableState<Actions, State>(initialState: State()) { [unowned self] (currentState, action) in
        switch action {
        case .login:
            return .merge(.just(with(currentState) { $0.processing = true } ), self.login(currentState) )
        }
    }

    // FORM BINDINGS

    lazy var fields = FormFields(username, password)

    lazy var username = FormTextField()
        .initialValue("hmlong")
        .required(min: 6)

    lazy var password = FormTextField()
        .required(min: 8)

    // FUNCTIONALITY

    func login(_ state: State) -> Observable<State> {
        guard let username = username.text, let password = password.text, fields.isValid else {
            return .just(with(state) {
                $0.error = "Username and password are required."
            })
        }
        return User.login(username, password)
            .map { user in
                return with(state) {
                    $0.authenticated = user
                    $0.error = nil
                    $0.processing = false
                }
            }
            .catchError { e in
                return .just( with(state) {
                    $0.error = e.localizedDescription
                    $0.processing = false
                })
             }
    }
}

@discardableResult
public func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
    var this = item; try update(&this); return this
}

