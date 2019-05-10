//
//  LayoutTest.swift
//  Widgets
//
//  Created by Michael Long on 3/26/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class LayoutViewController: UIViewController {

    var context = WidgetContext.defaultContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Container Position"
        view.add(widget: getWidgets(), with: context)
    }

    func getWidgets() -> Widget {

        func makeTestBlock(_ name: String, _ position: WidgetPosition) -> Widget {
            return ContainerWidget(
                ContainerWidget(
                    LabelWidget()
                        .text(name)
                        .text(color: .white)
                        .text(align: .center)
                    )
                    .backgroundColor(.black)
                    .width(min: 80)
                    .padding(h: 10, v: 5)
                )
                .backgroundColor(.lightGray)
                .position(position)
                .height(45)
        }

        return VerticalScrollWidget(
            SafeAreaWidget(
                ColumnWidget([
                    makeTestBlock("Top", .top),
                    RowWidget([
                        makeTestBlock("Left", .left),
                        makeTestBlock("Right", .right),
                        ])
                        .distribution(.fillEqually),
                    makeTestBlock("Bottom", .bottom),

                    SpacingWidget().height(10),

                    RowWidget([
                        makeTestBlock("Top Left", .topLeft),
                        makeTestBlock("Top Rigth", .topRight),
                        ])
                        .distribution(.fillEqually),
                    RowWidget([
                        makeTestBlock("Bottm Left", .bottomLeft),
                        makeTestBlock("Bottom Right", .bottomRight),
                        ])
                        .distribution(.fillEqually),

                    SpacingWidget().height(10),

                    makeTestBlock("Center", .center),

                    SpacingWidget().height(10),

                    makeTestBlock("Fill", .fill),

//                    SpacingWidget().height(10),
//
//                    makeTestBlock("Fill Top", .fillTop),
//                    RowWidget([
//                        makeTestBlock("Fill Left", .fillLeft),
//                        makeTestBlock("Fill Right", .fillRight),
//                        ])
//                        .distribution(.fillEqually),
//                     makeTestBlock("Fill Bottom", .fillBottom),
                    ])
                    .spacing(10)
                    .padding(30)
                )
            )
            .backgroundColor(.white)

    }

}
