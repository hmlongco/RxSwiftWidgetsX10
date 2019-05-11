//
//  SimpleTableViewModel.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftWidgets

class SimpleTableViewModel {

    lazy var users = BehaviorRelay<[User]>(value: User.users)

    func reload() {
        DispatchQueue.main.delay(1.0, execute: {
            self.users.accept(User.users)
        })
    }

}
