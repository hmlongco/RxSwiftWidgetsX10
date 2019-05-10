//
//  SpinnerView.swift
//
//  Created by Michael Long on 5/22/18.
//

import UIKit

class SpinnerView: UIView {

    @IBInspectable
    var height: CGFloat = 50

    var activityView = UIActivityIndicatorView()

    weak var heightConstraint: NSLayoutConstraint?

    convenience init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: height))
        self.height = height
        commonSetup()
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
        heightAnchor.constraint(equalToConstant: height).isActive = true

        backgroundColor = .clear

        activityView.isHidden = false
        activityView.color = .gray
        activityView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(activityView)

        centerXAnchor.constraint(equalTo: activityView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: activityView.centerYAnchor).isActive = true

        activityView.startAnimating()
    }

}
