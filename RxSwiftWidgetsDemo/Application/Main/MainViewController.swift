//
//  MainViewController.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {

    let viewModel = MainViewModel()
    var context = WidgetContext.defaultContext()
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

    enum NetworkError: Error {
        case url
        case server
        case timeout
    }

    lazy var firstTimeOnly: () -> Void = { [unowned self] in
        DispatchQueue.main.delay(0.1, execute: {
            self.showViewController(of: SimpleTableViewController.self)
        })
        return {}
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.add(widget: getScaffolding(), with: context)
   }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
//        firstTimeOnly()
    }

    func getScaffolding() -> Widget {
        return ScaffoldWidget(getBody())
            .background(getBackground())
    }

    func getBody() -> Widget {
        return VerticalScrollWidget(
            SafeAreaWidget(
                ColumnWidget([
                    CenterWidget(
                        ImageWidget()
                            .image(named: "RxSwiftWidgets-Logo-DK")
                            .height(150)
                            .width(150)
                            .clipRadius(20)
                        )
                        .padding(top: 20, left: 40, bottom: 10, right: 40),

                    ColumnWidget(
                        viewModel.samples.map { sample -> Widget in
                            return TappableWidget(
                                CenterWidget(
                                    LabelWidget()
                                        .text(sample.name)
                                        .text(font: UIFont.preferredFont(forTextStyle: .title3))
                                        .text(color: .black)
                                    )
                                    .alpha(0.6)
                                    .backgroundColor(.white)
                                    .padding(h: 16, v: 8)
                                    .clipRadius(10)
                                )
                                .onTap({ [weak self] in
                                    self?.showViewController(of: sample.type)
                                })
                            }
                        )
                        .padding(top: 0, left: 30, bottom: 10, right: 30)
                        .spacing(20),

                    LabelWidget()
                        .alpha(0.6)
                        .text("RxSwiftWidgets Demo Version \(version)\n\nCreated by Michael Long\nLinkedIn: hmlongco\nTwitter: @hmlco")
                        .text(align: .center)
                        .text(color: .white)
                        .text(font: UIFont.preferredFont(forTextStyle: .caption1))
                        .numberOfLines(0)
                        .padding(h: 40, v: 20),
                    ])
                )
            )
    }

    func getBackground() -> Widget {
        return ImageWidget()
            .image(named: "vector1")
    }

    func showViewController(of type: UIViewController.Type) {
        let vc = type.init()
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = false
    }

 }
