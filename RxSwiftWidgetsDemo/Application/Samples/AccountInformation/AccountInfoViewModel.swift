//
//  AccountInfoViewModel.swift
//  Widgets
//
//  Created by Michael Long on 12/30/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountInfoViewModel {

    var processing: Observable<Bool>!
    var error: Observable<String>!

    lazy var loaded = accountInformation.map{ _ in true }.startWith(false)
    lazy var title = accountInformation.map { $0.name }
    lazy var accountDetails = accountInformation.map { Array($0.details.prefix(2)) }
    lazy var paymentDetails = accountInformation.map { Array($0.details.dropFirst(2)) }
    lazy var footnotes = accountInformation.map { $0.footnotes }

    private var accountInformation: Observable<AccountInformation>!

    func actions(_ load: Observable<Void>) {
        let loading = load
            .flatMapLatest { AccountInformation.load().materialize() }
            .share()

        accountInformation = loading
            .compactMap { $0.element }
            .share()

        error = loading
            .compactMap { $0.error?.localizedDescription }

        processing = Observable
            .merge(load.map{_ in true}, loading.map{_ in false})
    }

}
