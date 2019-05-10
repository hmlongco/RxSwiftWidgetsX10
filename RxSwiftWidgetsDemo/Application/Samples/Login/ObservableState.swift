//
//  EnumeratedState.swift
//  Widgets
//
//  Created by Michael Long on 5/1/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class ObservableState<Action, State> {

    public var actions = PublishSubject<Action>()

    public var currentState: State!

    private var state: Observable<State>!

    init(initialState: State, reduce: @escaping (_ action: Action) -> Observable<State>) {
        self.state = actions
            .flatMapLatest { action in
                return reduce(action)
            }
            .do(onNext: { [weak self] state in
                self?.currentState = state
            })
            .observeOn(MainScheduler.instance)
            .share()
            .startWith(initialState)
    }

    public func asObservable() -> Observable<State> {
        return state
    }

    public func next(_ action: Action) {
        actions.onNext(action)
    }

}
