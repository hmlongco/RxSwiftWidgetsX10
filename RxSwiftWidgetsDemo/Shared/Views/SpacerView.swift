//
//  SpacerView.swift
//
//  Created by Michael Long on 5/22/18.
//

import UIKit

class SpacerView: UIView {

    @IBInspectable
    var height: Int = 0

    weak var heightConstraint: NSLayoutConstraint?

    convenience init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: height))
        addConstraint(height: height)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    func commonSetup() {
        if height > 0 {
            addConstraint(height: CGFloat(height))
        }
    }

    func addConstraint(height: CGFloat) {
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
    }

}
