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


class FormLoginViewModel {

    // DEFINITIONS

    enum Actions {
        case login
    }

    enum State {
        case initial

        case authenticated(User)
        case error(String)
        case processing(Bool)

        var processing: Bool? { if case let .processing(status) = self { return status }; return nil }
     }

    // DYNAMIC BINDINGS

    lazy var fields = FormFields(username, password)

    lazy var username = FormTextField()
        .initialValue(rememberedUsername)
        .required(min: 6)

    lazy var password = FormTextField()
        .required(min: 8)

    lazy var state = ObservableState<Actions, State>(initialState: .initial) { [unowned self] action in
        switch action {
        case .login:
            return .concat(.just(.processing(true)), self.login(), .just(.processing(false)))
        }
    }

    lazy var processing: Observable<Bool> = state.asObservable().compactMap { $0.processing }

    // STATIC BINDINGS

    lazy var rememberedUsername = "hmlong"
    lazy var helpString: String = "Contact Client Resources, Inc."

    // FUNCTIONALITY

    func login() -> Observable<State> {
        guard let username = username.text, let password = password.text, fields.isValid else {
            return .just(.error("Username and password are required."))
        }
        return User.login(username, password)
            .map { .authenticated($0) }
            .catchError { .just(.error($0.localizedDescription)) }
    }
}
