//
//  VerticalScrollWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class ScrollWidget: WidgetBase<UIScrollView>, WidgetChildManaging {

    var contentsShouldAvoidKeyboard = false

    required public init(_ child: Widget) {
        super.init()
        self.children = [child]
        self.position = .fill
    }

    override open func buildInitialView(with context: WidgetContext) -> UIScrollView? {
        return UIScrollView()
    }

    override open func applyProperties(to view: UIScrollView, with context: WidgetContext) {
       super.applyProperties(to: view, with: context)

        if let subview = child?.build(context) {
            view.addSubview(subview)
            child?.viewAddedToSuperview()
        }

        avoidKeyboard(view, with: context)
    }

    public func avoidKeyboard(_ scrollView: UIScrollView, with context: WidgetContext) {
        guard contentsShouldAvoidKeyboard else { return }

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak scrollView] (notification) in
                guard let scrollView = scrollView, let window = scrollView.window else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let info: NSDictionary = notification.userInfo! as NSDictionary
                    // get keyboard frame in window coordinate space
                    let keyboardFrameInWindow = ((info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
                    // get scrollview frame in window coordinate space
                    let scrollViewFrameInWindow = scrollView.convert(scrollView.frame, to: window)
                    // compute intersection
                    let intersection = scrollViewFrameInWindow.intersection(keyboardFrameInWindow)
                    // if intersects, inset scrollview by that amount
                    if intersection.height > 0 {
                        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: intersection.height, right: 0)
                        scrollView.contentInset = contentInsets
                        scrollView.scrollIndicatorInsets = contentInsets
                    }
                }
            })
            .disposed(by: context.disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak scrollView] _ in
                if let scrollView = scrollView, scrollView.contentInset.bottom > 0 {
                    scrollView.contentInset = UIEdgeInsets.zero
                    scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
                }
            })
            .disposed(by: context.disposeBag)

    }

    public func contentsShouldAvoidKeyboard(_ avoid: Bool) -> Self {
        contentsShouldAvoidKeyboard = avoid
        return self
    }

}
