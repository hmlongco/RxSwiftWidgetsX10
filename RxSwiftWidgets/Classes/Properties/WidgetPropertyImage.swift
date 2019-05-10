//
//  WidgetPropertyImage.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - Image

public struct WidgetPropertyImage: WidgetPropertyApplying {
    static public var key = "WidgetPropertyImage"
    public var image: UIImage?
    public func apply(to widget: Widget, with context: WidgetContext) {
        guard let view = widget.view as? UIImageView else { return }
        view.image = image
    }
}

public protocol WidgetPropertyImageSupported {
    func image(_ image: UIImage?) -> Self
}

public extension WidgetPropertyImageSupported where Self : Widget {
    func image(_ image: UIImage?) -> Self {
        setProperty(WidgetPropertyImage(image: image))
        return self
    }
}

// Widget Property - Image Named

public struct WidgetPropertyImageNamed: WidgetPropertyApplying {
    static public var key = "WidgetPropertyImageNamed"
    public var name: String?
    public func apply(to widget: Widget, with context: WidgetContext) {
        guard let view = widget.view as? UIImageView, let name = name else { return }
        view.image = UIImage(named: name)
    }
}

public protocol WidgetPropertyImageNamedSupported {
    func image(_ image: UIImage?) -> Self
}

public extension WidgetPropertyImageNamedSupported where Self : Widget {
    func image(named name: String?) -> Self {
        setProperty(WidgetPropertyImageNamed(name: name))
        return self
    }
}

// Widget Property - Image Binding

public struct WidgetPropertyImageBinding: WidgetPropertyApplying {
    static public var key = "WidgetPropertyImageBinding"
    public var observable: Observable<UIImage?>
    public func apply(to widget: Widget, with context: WidgetContext) {
        guard let view = widget.view as? UIImageView else { return }
        observable.bind(to: view.rx.image).disposed(by: context.disposeBag)
    }
}

public protocol WidgetPropertyImageBindingSupported {
    func image(bind observable: Observable<UIImage?>) -> Self
}

public extension WidgetPropertyImageBindingSupported where Self : Widget {
    func image(bind observable: Observable<UIImage?>) -> Self {
        setProperty(WidgetPropertyImageBinding(observable: observable))
        return self
    }
}
