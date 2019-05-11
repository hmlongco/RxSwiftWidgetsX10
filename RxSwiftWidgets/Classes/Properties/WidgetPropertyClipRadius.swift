//
//  WidgetPropertyClipRadius.swift
//  Widgets
//
//  Created by Michael Long on 2/27/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Property - ClipRadius

public struct WidgetPropertyClipRadius: WidgetPropertyApplying {
    static public var key = "WidgetPropertyClipRadius"
    public var clipRadius: CGFloat
    public init(clipRadius: CGFloat) {
        self.clipRadius = clipRadius
    }
    public func apply(to widget: Widget, with context: WidgetContext) {
        guard let view = widget.view else { return }
        view.clipsToBounds = true
        view.layer.cornerRadius = clipRadius
    }
}

public protocol WidgetPropertyClipRadiusSupported {
    func clipRadius(_ clipRadius: CGFloat) -> Self
}

public extension WidgetPropertyClipRadiusSupported where Self : Widget {
    func clipRadius(_ clipRadius: CGFloat) -> Self {
        setProperty(WidgetPropertyClipRadius(clipRadius: clipRadius))
        return self
    }
}

extension WidgetBase: WidgetPropertyClipRadiusSupported {}
