//
//  MainCoordinator.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainCoordinator: Coordinator {

    func showInformation(for user: User) {
        let vc = UserInfoViewController()
        vc.currentUser = user
        currentNavigationController()?.pushViewController(vc, animated: true)
    }

}
