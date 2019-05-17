//
//  ObservableState
//  Widgets
//
//  Created by Michael Long on 5/1/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxSwiftWidgets

extension Observable {
    static func constant(_ value: Element) -> Observable<Element> {
        return BehaviorRelay(value: value).asObservable()
    }
}

class ObservableState<Action, State> {

    public var actions = PublishSubject<Action>()

    public var currentState: State!

    private var state: Observable<State>!

    init(initialState: State, reduce: @escaping (_ action: Action) -> Observable<State>) {
        self.currentState = initialState
        self.state = actions
            .flatMapLatest { action -> Observable<State> in
                return reduce(action)
            }
            .do(onNext: { [weak self] state in
                self?.currentState = state
            })
            .observeOn(MainScheduler.instance)
            .share()
            .startWith(initialState)
    }

    init(initialState: State, reduce: @escaping (_ state: State, _ action: Action) -> Observable<State>) {
        self.currentState = initialState
        self.state = actions
            .flatMapLatest { [weak self] action -> Observable<State>  in
                guard let self = self else { return .empty() }
                return reduce(self.currentState, action)
            }
            .do(onNext: { [weak self] state in
                self?.currentState = state
            })
            .observeOn(MainScheduler.instance)
            .share()
            .startWith(currentState)
    }

    public func asObservable() -> Observable<State> {
        return state
    }

    public func next(_ action: Action) {
        actions.onNext(action)
    }

}
