//
//  MainViewModel.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftWidgets

class MainViewModel {

    struct Sample {
        let name: String
        let type: UIViewController.Type
    }

    let samples = [
        Sample(name: "Account Information", type: AccountInfoViewController.self),
        Sample(name: "Solutions Login", type: LoginViewController.self),
//        Sample(name: "User Information", type: UserInfoViewController.self),
        Sample(name: "User List", type: SimpleTableViewController.self),
//        Sample(name: "Layout Position", type: LayoutViewController.self),
    ]

}
