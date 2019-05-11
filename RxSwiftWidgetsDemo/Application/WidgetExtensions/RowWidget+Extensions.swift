//
//  RowWidget+Extensions.swift
//  Widgets
//
//  Created by Michael Long on 3/6/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftWidgets

extension RowWidget {
    static func nameWidgetRow(name: String, widget: Widget) -> RowWidget {
        return RowWidget([
                LabelWidget().text(name).text(color: .gray),
                widget
            ])
    }
}

extension RowWidget {
    static func nameValueRow(name: String, value: String?) -> RowWidget {
        return RowWidget([
                LabelWidget().text(name).text(color: .gray),
                LabelWidget().text(value).text(align: .right)
            ])
    }
    static func nameValueRow(name: String, bind observable: Observable<String?>) -> RowWidget {
        return RowWidget([
                LabelWidget().text(name).text(color: .gray),
                LabelWidget().text(bind: observable).text(align: .right)
            ])
    }
}
