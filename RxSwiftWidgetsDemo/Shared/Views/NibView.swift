//
//  NibView.swift
//  FNB-Beta
//
//  Created by Michael Long on 5/15/18.
//  Copyright © 2018 First National Bank. All rights reserved.
//

import UIKit

public protocol NibLoading {
    func loadNib() -> UIView?
    func xibSetup()
}

public class NibView: UIView, NibLoading {
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
}

public class NibControl: UIControl, NibLoading {
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
}

extension NibLoading where Self:UIView {
    /** Loads instance from nib with the same name. */
    public func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    public func xibSetup() {
        backgroundColor = UIColor.clear
        guard let view = loadNib() else { return }
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        // Adding custom subview on top of our view
        addSubview(view)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
}
