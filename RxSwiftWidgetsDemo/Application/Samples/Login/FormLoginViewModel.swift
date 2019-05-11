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

    enum Actions {
        case login
    }

    enum State {
        case initial
        case processing(Bool)
        case authenticated(User)
        case error(String)
     }

    lazy var username = FormTextField()
        .initialValue(rememberedUsername)
        .required(min: 6)

    lazy var password = FormTextField()
        .required(min: 8)

    lazy var fields = FormFields(username, password)

    lazy var rememberedUsername = "hmlong"
    lazy var helpString: String = "Contact Client Resources, Inc."

    lazy var state = ObservableState<Actions, State>(initialState: .initial) { [unowned self] action in
        switch action {
        case .login:
            return self.login()
        }
    }

    func login() -> Observable<State> {
        guard let username = username.text, let password = password.text, fields.isValid else {
            return .just(.error("Username and password are required."))
        }
        return .concat(
            .just(.processing(true)),
            User.login(username, password)
                .map { .authenticated($0) }
                .catchError { .just(.error($0.localizedDescription)) },
            .just(.processing(false))
        )
    }

}
