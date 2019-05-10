//
//  ContainerWidget.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift

open class ContainerWidget: WidgetBaseContainer<UIView>, WidgetChildManaging {

    internal var observable: Observable<Widget>?

    required public init(_ child: Widget) {
        super.init()
        self.children = [child]
    }

    override open func buildInitialView(with context: WidgetContext) -> UIView? {
        return WidgetPrivateContainerView()
    }

    override open func applyProperties(to view: UIView, with context: WidgetContext) {
        guard let view = view as? WidgetPrivateContainerView else { return }
        
        view.backgroundColor = .clear

        super.applyProperties(to: view, with: context)

        if let childView = child?.build(context) {
            view.addSubview(childView)
            child?.viewAddedToSuperview()
        }

        if let observable = observable {
            view.subscribe(to: observable, with: context)
        }

    }

    public func contents(bind observable: Observable<Widget>) -> Self {
        self.observable = observable
        return self
    }

    public func height(proportional height: CGFloat) -> Self {
        self.height = .proportional(height)
        return self
    }
    
    public func width(proportional width: CGFloat) -> Self {
        self.width = .proportional(width)
        return self
    }
}

internal class WidgetPrivateContainerView: UIView {

    var position: WidgetPosition!
    var padding: WidgetPadding!
    var disposeBag: DisposeBag!

    var proportionalHeight: CGFloat?
    var proportionalWidth: CGFloat?

    override open var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if let proportionalHeight = proportionalHeight {
            size.height = proportionalHeight
        }
        if let proportionalWidth = proportionalWidth {
            size.width = proportionalWidth
        }
        return size
    }

    public func subscribe(to observable: Observable<Widget>, with context: WidgetContext) {
        observable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (widget) in

                self.disposeBag = DisposeBag()
                var context = context
                context.disposeBag = self.disposeBag

                self.subviews.forEach {
                    $0.removeFromSuperview()
                }

                if let widgetView = widget.build(context) {
                    self.addSubview(widgetView)
                    self.position.constrain(parent: self, child: widgetView, with: self.padding)
                    widget.viewAddedToSuperview()
                }

                UIView.animate(withDuration: 0.01, animations: {
                    self.layoutIfNeeded()
                })
            })
            .disposed(by: context.disposeBag)
    }

}
