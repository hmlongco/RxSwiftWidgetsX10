//
//  UserInfoViewController.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class UserInfoViewController: UIViewController {

    let viewModel = UserInfoViewModel()
    var context = WidgetContext.defaultContext()
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User Information"

        viewModel.configure(currentUser)
        view.add(widget: getScaffolding(), with: context)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.nextUser()
            })
            .disposed(by: context.disposeBag)
    }

    func getScaffolding() -> Widget {
        return ScaffoldWidget(getBody())
            .backgroundImage(UIImage(named: "vector2"))
    }

    func getBody() -> Widget {

        return VerticalScrollWidget(
            GestureWidget(
                SafeAreaWidget(
                    ColumnWidget([
                        CenterWidget(
                            RowWidget([
                                OverlayWidget([
                                    LabelWidget()
                                        .backgroundColor(.red)
                                        .text(bind: viewModel.initials)
                                        .text(align: .center)
                                        .text(color: .white)
                                        .text(font: .preferredFont(forTextStyle: .largeTitle)),
                                    ImageWidget()
                                        .image(bind: viewModel.image)
                                        .height(60)
                                        .width(60)
                                        .with { image, _ in
                                            image.contentMode = .scaleAspectFill
                                    }
                                    ])
                                    .clipRadius(30),
                                LabelWidget()
                                    .text(align: .center)
                                    .text(bind: viewModel.name)
                                    .text(color: .red)
                                    .text(font: UIFont.preferredFont(forTextStyle: .title1))
                                ])
                                .align(vertical: .center)
                                .padding(h: 0, v: 10)
                        ),

                        SpacingWidget(),

                        TappableWidget(
                            ContainerWidget(
                                ContextWidget(
                                    RowWidget.nameValueRow(name: "Email Address", bind: viewModel.currentUser.map { $0.email })
                                    )
                                    .set(WidgetPropertyTextColor(color: .red))
                                )
                                .backgroundColor(Style.shared.sectionBackgroundColor)
                                .padding(15)
                                .clipRadius(15)
                                .hidden(bind: viewModel.hidden)
                            )
                            .onTap({ [weak self] in
                                self?.show(alert: "Email Address was tapped.")
                            }),

                        SpacingWidget()
                            .height(10)
                            .hidden(bind: viewModel.hidden),

                        ContainerWidget(
                            ColumnWidget([
                                RowWidget
                                    .nameValueRow(name: "Address", bind: viewModel.address)
                                    .hidden(bind: viewModel.hidden),
                                RowWidget
                                    .nameValueRow(name: "City", bind: viewModel.city),
                                RowWidget
                                    .nameValueRow(name: "State", bind: viewModel.state),
                                RowWidget
                                    .nameValueRow(name: "Zip Code", bind: viewModel.zip)
                                    .hidden(bind: viewModel.hidden)
                                ])
                            )
                            .backgroundColor(Style.shared.sectionBackgroundColor)
                            .padding(15)
                            .clipRadius(15),

                        RowWidget([
                            LabelWidget
                                .footnote()
                                .text("Your privacy is safe with us. Promise!")
                            ])
                            .hidden(bind: viewModel.hidden.map { !$0 })
                            .padding(h: 15, v: 0),

                        CenterWidget(
                            ButtonWidget()
                                .text("Privacy")
                                .text(color: Style.shared.primaryColor)
                                .backgroundColor(Style.shared.sectionBackgroundColor)
                                .padding(top: 5, left: 10, bottom: 8, right: 10)
                                .clipRadius(10)
                                .onTap({ [weak self] _ in
                                    UIView.animate(withDuration: 0.4, animations: {
                                        self?.viewModel.toggleHidden()
                                    })
                                })
                            )
                            .padding(15)
                        ])
                        .padding(top: 30, left: 25, bottom: 100, right: 25)
                        .defaultRowPadding(h: 0, v: 0)
                    )
                )
                .onSwipeLeft({ [weak self] in
                    self?.viewModel.nextUser()
                })
                .onSwipeRight({ [weak self] in
                    self?.viewModel.previousUser()
                })

        )

    }

}
