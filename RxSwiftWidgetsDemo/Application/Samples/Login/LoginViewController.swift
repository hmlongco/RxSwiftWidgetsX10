//
//  LoginViewController.swift
//  Widgets
//
//  Created by Michael Long on 3/31/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftWidgets

class LoginViewController: UIViewController {

    let errorID = 1

    var viewModel = LoginViewModel()
    var context = WidgetContext.defaultContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account Login"
        setupObservables()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func setupObservables() {
        viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }

                switch state {

                case .initial:
                    self.view.add(widget: self.getScaffolding(), with: self.context)

                case let .processing(processing):
                    self.blockingSpinner.animate(processing)

                case .authenticated:
                    self.navigationController?.popViewController(animated: true)

                case let .error(message):
                    if let label = self.view.viewWithTag(self.errorID) as? UILabel {
                        UIView.animate(withDuration: 0.3, animations: {
                            label.isHidden = message.isEmpty
                            label.text = message
                            label.layoutIfNeeded()
                        })
                    }
                }
            })
            .disposed(by: context.disposeBag)
    }

    func getScaffolding() -> Widget {
        return ScaffoldWidget(getBody())
            .background(getBackground())
            .header(getHeader())
            .footer(getFooter())
    }

    func getBody() -> Widget {
        return VerticalScrollWidget(
            SafeAreaWidget(
                ColumnWidget([
                    ContainerWidget(
                        ImageWidget()
                            .image(named: "Solutions-Center-logo")
                            .height(100)
                            .with({ image, _ in
                                image.contentMode = .scaleAspectFit
                            })
                        )
                        .position(.center)
                        .padding(h: 60, v: 10),

                    LabelWidget()
                        .id(errorID)
                        .alpha(0.8)
                        .text(color: .white)
                        .text(font: .preferredFont(forTextStyle: .callout))
                        .numberOfLines(0)
                        .padding(top: 0, left: 40, bottom: 15, right: 40),

                    ContainerWidget(
                        TextFieldWidget()
                            .placeholder("Username")
                            .text(viewModel.rememberedUsername)
                            .text(font: .title3)
                            .onTextChanged({ [unowned self] (text) in
                                self.viewModel.state.next(.updateUsername(text ?? ""))
                            })
                            .with({ field, _ in
                                field.textContentType = .username
                            })
                        )
                        .alpha(0.7)
                        .backgroundColor(Style.shared.sectionBackgroundColor)
                        .padding(h: 40, v: 10),

                    SpacingWidget(),

                    ContainerWidget(
                        TextFieldWidget()
                            .placeholder("Password")
                            .text(font: .title3)
                            .onTextChanged({ [unowned self] (text) in
                                self.viewModel.state.next(.updatePassword(text ?? ""))
                            })
                            .with({ field, _ in
                                field.textContentType = .password
                                field.isSecureTextEntry = true
                            })
                        )
                        .alpha(0.7)
                        .backgroundColor(Style.shared.sectionBackgroundColor)
                        .padding(h: 40, v: 10),

                    CenterWidget(
                        ButtonWidget()
                            .text("Need Help?")
                            .text(color: .orange)
                            .text(font: .footnote)
                            .onTap({ [unowned self] _ in
                                self.show(alert: self.viewModel.helpString)
                            })
                        )
                        .padding(h: 0, v: 10),

                    ])
                    .padding(top: 10, left: 0, bottom: 30, right: 0)
                )
            )

    }

    func getBackground() -> Widget {
        return ImageWidget()
            .image(named: "vector1")
    }

    func getHeader() -> Widget {
        return SafeAreaWidget(
            ContainerWidget(
                ButtonWidget()
                    .alpha(0.7)
                    .text("X")
                    .text(color: .white)
                    .text(font: .title2)
                    .onTap({ [unowned self] _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                )
                .position(.right)
                .padding(h: 20, v: 0)
        )
    }

    func getFooter() -> Widget {
        return SafeAreaWidget(
            ContainerWidget(
                ButtonWidget()
                    .alpha(0.8)
                    .text("Login")
                    .text(color: .white)
                    .text(font: .title3)
                    .backgroundColor(.black)
                    .padding(h: 20, v: 15)
                    .onTap({ [unowned self] _ in
                        self.viewModel.state.next(.login)
                    })
                )
            )
    }

}

