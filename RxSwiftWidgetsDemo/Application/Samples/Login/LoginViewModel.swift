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

class LoginViewModel {

    enum Actions {
        case updatedUsername(String)
        case updatedPassword(String)
        case login
    }

    enum State {
        case initial
        case processing(Bool)
        case authenticated(User)
        case error(String)
    }

    lazy var rememberedUsername = "hmlong"

    lazy var username: String = rememberedUsername
    lazy var password: String = ""

    var helpString: String = "Contact Client Resources, Inc."

    lazy var state = ObservableState<Actions, State>(initialState: .initial) { [weak self] action in
        if let self = self {
            switch action {
            case let .updatedUsername(text):
                self.username = text
            case let .updatedPassword(text):
                self.password = text
            case .login:
                return self.login(self.username, self.password)
            }
        }
        return .empty()
    }

    func login(_ username: String, _ password: String) -> Observable<State> {
        guard !username.isEmpty, !password.isEmpty else {
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
