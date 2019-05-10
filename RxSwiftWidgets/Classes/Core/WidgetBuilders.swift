//
//  WidgetBuilders.swift
//  Widgets
//
//  Created by Michael Long on 3/3/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Building

public protocol ObservableListBuilderType {

    associatedtype Item

    var items: Observable<[Item]> { get }

    func widget(for item: Item) -> Widget?

}

public struct ObservableListBuilder<Item>: ObservableListBuilderType {

    public let items: Observable<[Item]>

    private let builder: (_ item: Item) -> Widget?

    public init(_ items: Observable<[Item]>, builder: @escaping (_ item: Item) -> Widget) {
        self.items = items
        self.builder = builder
    }

    public func widget(for item: Item) -> Widget? {
        return builder(item)
    }

}

public struct AnyObservableListBuilder: ObservableListBuilderType {

    public typealias Item = Any

    public let items: Observable<[Any]>

    private let builder: (_ item: Any) -> Widget?

    public init<O:ObservableListBuilderType>(_ builder: O) {
        self.items = builder.items.map { $0 as [Any] }
        self.builder = { item in
            if let item = item as? O.Item {
                return builder.widget(for: item)
            }
            return nil
        }
    }

    public func widget(for item: Any) -> Widget? {
        return builder(item)
    }

}
