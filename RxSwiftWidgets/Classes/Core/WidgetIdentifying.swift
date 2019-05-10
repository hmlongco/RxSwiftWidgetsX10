//
//  WidgetIdentifying.swift
//  Widgets
//
//  Created by Michael Long on 3/7/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public protocol WidgetIdentifying: class {

    var id: Int { get set }

    func id(_ id: Int) -> Self
    func id<T>(_ id: T) -> Self where T: RawRepresentable, T.RawValue == Int

    func find(id: Int) -> Widget?
    func find<T>(id: T) -> Widget? where T: RawRepresentable, T.RawValue == Int

}

public extension WidgetIdentifying where Self : Widget {

    func id(_ id: Int) -> Self {
        self.id = id
        return self
    }

    func id<T>(_ id: T) -> Self where T: RawRepresentable, T.RawValue == Int {
        self.id = id.rawValue
        return self
    }

    func find(id: Int) -> Widget? {
        if self.id == id {
            return self
        }
        for child in children {
            if let result = child.find(id: id) {
                return result
            }
        }
        return nil
    }

    func find<T>(id: T) -> Widget? where T: RawRepresentable, T.RawValue == Int {
        return find(id: id.rawValue)
    }

}

public extension UIView {
    func viewWithID<T,V:UIView>(_ id: T) -> V? where T: RawRepresentable, T.RawValue == Int {
        return viewWithTag(id.rawValue) as? V
    }
}
