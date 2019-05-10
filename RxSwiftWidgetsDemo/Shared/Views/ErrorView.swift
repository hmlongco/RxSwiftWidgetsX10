//
//  ErrorView.swift
//  FNB-Beta
//
//  Created by Michael Long on 4/12/18.
//  Copyright © 2018 First National Bank. All rights reserved.
//

import RxSwift
import RxCocoa
// import RxSwiftForms

class ErrorView: UIView {

    var errorMessage: String? {
        didSet {
            handleErrorMessage(errorMessage)
        }
    }

    var margin: CGFloat = 16

    private var errorLabel: UILabel!
    private var errorHeight: NSLayoutConstraint!

    private var animatingErrorMessage = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    func commonSetup() {

        backgroundColor = UIColor.errorBannerBackground

        let label = UILabel(frame: CGRect.zero)
        label.text = nil
        label.textColor = UIColor.errorBannerText
        label.font = UIFont.error
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        errorLabel = label

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        errorHeight = heightAnchor.constraint(equalToConstant: 0)
        errorHeight.isActive = true
    }

    func handleErrorMessage(_ message: String?) {
        showErrorMessage(message)
    }

    func showErrorMessage(_ message:String?) {
        guard animatingErrorMessage == false else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.showErrorMessage(message)
            }
            return
        }

        let isEmpty = message?.isEmpty ?? true
        let isHidden = errorHeight.constant == 0

        if isHidden == true && isEmpty == false {
            show(message)
        } else if isHidden == false {
            hideThenShow(message)
        }
    }

    private func show(_ message: String?) {
        animatingErrorMessage = true
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1
            self.errorLabel.text = message
            self.errorLabel.sizeToFit()
            self.errorHeight.constant = self.errorLabel.frame.height + (self.margin * 2)
            self.superview?.layoutIfNeeded()
            self.isHidden = false
        }, completion: { (done) in
            if done {
                self.doneAnimating()
            }
        })
    }

    private func hideThenShow(_ message: String?) {
        animatingErrorMessage = true
        UIView.animate(withDuration: isHidden ? 0.1 : 0.3, animations: {
            self.alpha = 0
            self.errorLabel.text = nil
            self.errorLabel.sizeToFit()
            self.errorHeight.constant = 0
            self.superview?.layoutIfNeeded()
        }, completion: { (done) in
            if done {
                if let message = message, !message.isEmpty {
                    self.show(message)
                } else {
                    self.doneAnimating()
                }
            }
        })
    }

    func doneAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.animatingErrorMessage = false
        }
    }
}
