//
//  UIViewController+Extensions.swift
//  Widgets
//
//  Created by Michael Long on 3/9/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

extension UIViewController {

    func show(alert: String) {
        let alert = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        navigationController?.present(alert, animated: true, completion: nil)
    }

}
