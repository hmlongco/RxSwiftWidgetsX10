//
//  WidgetPropertyBackgroundImage.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - BackgroundImage

public struct WidgetPropertyBackgroundImage: WidgetProperty {
    static public var key = "WidgetPropertyBackgroundImage"
    public var image: UIImage?
}

public protocol WidgetPropertyBackgroundImageSupported {
    func backgroundImage(_ image: UIImage?) -> Self
}

public extension WidgetPropertyBackgroundImageSupported where Self : Widget {
    func backgroundImage(_ image: UIImage?) -> Self {
        setProperty(WidgetPropertyBackgroundImage(image: image))
        return self
    }
}
