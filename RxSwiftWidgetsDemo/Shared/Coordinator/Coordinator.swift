//
//  Coordinator.swift
//  Dismissible
//
//  Created by Michael Long on 6/11/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift

class Coordinator {

    // If a navigation controller is provided currentNavigationController() will return it.
    //
    // Otherwise currentNavigationController() knows how to search the navigation stack and return the current topmost navgiation controller.
    //
    // Without it Coordinator would have to attempt to maintain its own copy of the navigation controller stack that could easily get out of sync
    // with the real world. It would also force us to require that every navigation action go through or hook into Coordinator, and that's
    // simply not realistic.
    //
    // As mentioned above, doing a simple 'go back' from nav bar could bypass Coordinator and the dismmisible.dismiss() calls, leaving a copy
    // of the navigation stack out of sync.

    public init(_ navigationController: UINavigationController? = nil) {
        useNavigationController = navigationController
    }

    public func use(_ navigationController: UINavigationController?) {
        useNavigationController = navigationController
    }

    public func currentNavigationController() -> UINavigationController? {

        if let navigationController = useNavigationController {
            return navigationController
        }

        func recurse(controller: UIViewController?) -> UIViewController? {
            if let navigationController = controller as? UINavigationController {
                return recurse(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return recurse(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return recurse(controller: presented)
            }
            return controller
        }

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return recurse(controller: rootViewController)?.navigationController
    }

    // Returns viewController if a viewController of type V is already on navigation stack.
    public func pushedViewControllerType<V>() -> V? {
        guard let currentNC = currentNavigationController() else {
            return nil
        }
        return currentNC.viewControllers.last(where: {vc in vc is V}) as? V
    }

    private weak var useNavigationController: UINavigationController?

}
