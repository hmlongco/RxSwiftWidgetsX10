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
        case updateUsername(String)
        case updatePassword(String)
        case login
    }

    enum State {
        case initial
        case authenticated(User)
        case error(String)
        case processing(Bool)
    }

    lazy var rememberedUsername = "hmlong"

    lazy var username: String = rememberedUsername
    lazy var password: String = ""

    var helpString: String = "Contact Client Resources, Inc."

    lazy var state = ObservableState<Actions, State>(initialState: .initial) { [weak self] action in
        if let self = self {
            switch action {
            case let .updateUsername(text):
                self.username = text
            case let .updatePassword(text):
                self.password = text
            case .login:
                return self.processingSequence(self.login(self.username, self.password))
            }
        }
        return .empty()
    }

    func login(_ username: String, _ password: String) -> Observable<State> {
        guard !username.isEmpty, !password.isEmpty else {
            return .just(.error("Username and password are required."))
        }
        return User.login(username, password)
            .map { .authenticated($0) }
            .catchError { .just(.error($0.localizedDescription)) }
    }

    func processingSequence(_ observable: Observable<State>) -> Observable<State> {
        return .concat(.just(.processing(true)), observable, .just(.processing(false)))
    }
}
