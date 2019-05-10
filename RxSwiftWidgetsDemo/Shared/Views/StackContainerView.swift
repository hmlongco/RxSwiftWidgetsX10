//
//  StackContainerView.swift
//  FNB-Beta
//
//  Created by Michael Long on 9/2/18.
//  Copyright © 2018 First National Bank. All rights reserved.
//

import UIKit

class StackContainerView: UIView {

    var stackView: UIStackView!

    @IBInspectable
    var spacing: CGFloat = 8.0 {
        didSet { stackView.spacing = spacing }
    }

    @IBInspectable
    var margins = UIEdgeInsets.zero

    convenience init(margins: UIEdgeInsets) {
        let frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 10) // placeholders, constraints will adjust
        self.init(frame: frame)
        self.margins = margins
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
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)

        let frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 10) // placeholders, constraints will adjust
        let stack = UIStackView(frame: frame)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        stack.setContentHuggingPriority(.required, for: .vertical)
        stack.setContentCompressionResistancePriority(.required, for: .vertical)

        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margins.left).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margins.right).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: margins.top).isActive = true
        stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant:  -margins.bottom).isActive = true

        stackView = stack
    }

    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    override func updateConstraints() {
        stackView.constraints.filter { $0.firstAnchor == stackView.leadingAnchor }.first?.constant = -margins.left
        stackView.constraints.filter { $0.firstAnchor == stackView.trailingAnchor }.first?.constant = margins.right
        stackView.constraints.filter { $0.firstAnchor == stackView.topAnchor }.first?.constant = -margins.top
        stackView.constraints.filter { $0.firstAnchor == stackView.bottomAnchor }.first?.constant = margins.bottom
        super.updateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if stackView.frame.size.height != size.height {
            stackView.frame.size.height = size.height
            frame.size.height = size.height + margins.top + margins.bottom
        }
    }

}
