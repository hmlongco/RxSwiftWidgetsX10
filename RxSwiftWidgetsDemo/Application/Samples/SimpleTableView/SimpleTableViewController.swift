//
//  SimpleTableViewController.swift
//  Widgets
//
//  Created by Michael Long on 3/28/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftWidgets

class SimpleTableViewController: UIViewController {

    let coordinator = MainCoordinator()
    let viewModel = SimpleTableViewModel()
    var context = WidgetContext.defaultContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"
        WidgetBuilder.add(widget: getScaffolding(), to: view, with: context)
    }

    func getScaffolding() -> Widget {
        return ScaffoldWidget(getBody())
            .backgroundImage(UIImage(named: "vector2"))
    }

    func getBody() -> Widget {

        return TableViewListWidget(
            ObservableListBuilder(self.viewModel.users.asObservable(), builder: { (user) -> Widget in
                return ContainerWidget(
                    SafeAreaWidget(
                        RowWidget([
                            OverlayWidget([
                                LabelWidget()
                                    .text(user.initials)
                                    .text(align: .center)
                                    .text(color: .white)
                                    .text(font: .preferredFont(forTextStyle: .title1)),
                                ImageWidget()
                                    .image(named: "User-\(user.initials ?? "")")
                                    .with({ image, _ in
                                        image.contentMode = .scaleAspectFill
                                    })
                                ])
                                .backgroundColor(.red)
                                .height(50)
                                .width(50)
                                .clipRadius(25),
                            LabelWidget()
                                .text(user.name)
                                .text(font: .preferredFont(forTextStyle: .title2))
                                .text(color: .red)
                            ])
                        )
                    )
                    .position(.left)
                    .padding(top: 15, left: 20, bottom: 10, right: 20)
                })
            )
            .onSelected({ [weak self] (tableView, _, user) in
                self?.coordinator.showInformation(for: user)
                tableView.deselect()
            })
            .header(
                ContainerWidget(
                    ContainerWidget(
                        SafeAreaWidget(
                            LabelWidget()
                                .text("UITableView Dynamic Widgets")
                                .text(color: .white)
                                .text(font: .title3)
                                .numberOfLines(0)
                            )
                        )
                        .alpha(0.8)
                        .backgroundColor(.red)
                        .padding(20)
                    )
                    .padding(top: 0, left: 0, bottom: 10, right: 0)
            )
            .footer(
                ContainerWidget(
                    ColumnWidget([
                        SpacingWidget()
                            .height(20),
                        SeparatorWidget(),
                        LabelWidget()
                            .text("Any resemblance to individuals living, dead, fictional, animated, or reanimated is purly coincidental. ")
                            .text(align: .left)
                            .text(color: .gray)
                            .text(font: .footnote)
                            .numberOfLines(0)
                            .padding(h: 0, v: 8)
                       ])
                       .padding(h: 15, v: 8)
                    )
            )
            .onRefresh({ [unowned self] control in
                self.viewModel.reload()
            })
            .backgroundColor(.clear)
            .with({ (tableView, _) in
                tableView.separatorStyle = .none
            })
    }

}
