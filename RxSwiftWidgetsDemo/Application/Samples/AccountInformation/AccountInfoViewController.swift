//
//  AccountInfoViewController.swift
//  Widgets
//
//  Created by Michael Long on 3/28/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class AccountInfoViewController: UIViewController {

    let viewModel = AccountInfoViewModel()
    var context = WidgetContext.defaultContext()
    var loadTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account Information"
        viewModel.actions(loadTrigger)
        view.add(widget: getWidgets(), with: context)
        loadTrigger.onNext(())
    }

    func getWidgets() -> Widget {

        return ScaffoldWidget(
            VerticalScrollWidget(
                SafeAreaWidget(
                    ColumnWidget([
                        CenterWidget(
                            SpinnerWidget()
                            )
                            .padding(h: 0, v: 20)
                            .hidden(bind: viewModel.processing.map { !$0 }),

                        LabelWidget()
                            .text(bind: viewModel.error.asObservable())
                            .text(color: .gray)
                            .numberOfLines(0)
                            .hidden(bind: viewModel.error.map { $0.isEmpty }),

                        ColumnWidget([
                            LabelWidget()
                                .text(align: .center)
                                .text(bind: viewModel.title)
                                .text(color: .red)
                                .text(font: UIFont.preferredFont(forTextStyle: .title1))
                                .padding(top: 0, left: 0, bottom: 10, right: 0),

                            ContainerWidget.section(
                                ColumnWidget([])
                                    .contents(bind: viewModel.accountDetails.map { details in
                                        return details.map {
                                            return RowWidget.nameValueRow(name: $0.name, value: $0.value)
                                        }
                                    })
                                ),

                            SpacingWidget(),

                            ContainerWidget.section(
                                ColumnWidget([])
                                    .contents(bind: viewModel.paymentDetails.map { details in
                                        return details.map {
                                            return RowWidget.nameValueRow(name: $0.name, value: $0.value)
                                        }
                                    })
                                ),

                            LabelWidget
                                .footnote()
                                .text(bind: viewModel.footnotes)
                                .padding(h: 15, v: 0)
                            ])
                            .hidden(bind: viewModel.loaded.map { !$0 })
                            .spacing(10),

                        ])
                        .padding(top: 20, left: 25, bottom: 30, right: 25)
                    )
                )
            )
            .backgroundImage(UIImage(named: "vector2"))


    }

}
