//
//  UserInfoViewModel.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftWidgets

class UserInfoViewModel {

    let users: [User] = User.users
    var userIndex = 0

    lazy var currentUser = BehaviorRelay<User>(value: users[0])
    lazy var hidden = BehaviorSubject<Bool>(value: false)

    lazy var name = currentUser.map { $0.name }
    lazy var address = currentUser.map { $0.address }
    lazy var city = currentUser.map { $0.city }
    lazy var state = currentUser.map { $0.state }
    lazy var zip = currentUser.map { $0.zip }
    lazy var email = currentUser.map { $0.email }
    lazy var initials = currentUser.map { $0.initials }

    lazy var image = currentUser.map {[weak self] user -> UIImage? in
        if let name = user.initials {
            return UIImage(named: "User-\(name)")
        }
        return nil
    }

    func configure(_ currentUser: User?) {
        if let currentUser = currentUser, let index = users.firstIndex(where: { $0.name == currentUser.name }) {
            self.currentUser = BehaviorRelay(value: users[index])
            self.userIndex = index
        }
    }

    func nextUser() {
        userIndex += 1
        currentUser.accept(users[userIndex % users.count])
    }

    func previousUser() {
        if userIndex == 0 {
            userIndex = users.count
        }
        userIndex -= 1
        currentUser.accept(users[abs(userIndex) % users.count])
    }

    func toggleHidden() {
        try? hidden.onNext(!hidden.value())
    }

}
