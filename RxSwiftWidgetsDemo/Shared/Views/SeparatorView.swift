//
//  SpacerView.swift
//
//  Created by Michael Long on 5/22/18.
//

import UIKit

class SeparatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    func commonSetup() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        let largestHeight  = heightAnchor.constraint(equalToConstant: 0.5)
        largestHeight.isActive = true
    }

}

extension UIView {

    func addTopSeparator() {
        var frame = bounds
        frame.size.height = 0.4
        let separator = SeparatorView(frame: frame)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        topAnchor.constraint(equalTo: separator.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: separator.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: separator.trailingAnchor).isActive = true
    }

    func addBottomSeparator() {
        var frame = bounds
        frame.size.height = 0.4
        let separator = SeparatorView(frame: frame)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        bottomAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: separator.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: separator.trailingAnchor).isActive = true
    }

}
