//
//  StateMachine.swift
//  Widgets
//
//  Created by Michael Long on 1/15/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StateMachineX<State> {

    public let state: Observable<State>

    public var currentState: State {
        return stateRelay.value
    }

    public func next(_ state: State) {
        if let nextState = transition?(currentState, state) {
            stateRelay.accept(nextState)
        }
    }

    private var transition: ((_ fromState: State, _ toState: State) -> State?)?
    private var stateRelay: BehaviorRelay<State>!

    init(initialState: State, transition: ((_ fromState: State, _ toState: State) -> State?)? = nil) {
        self.stateRelay = BehaviorRelay(value: initialState)
        self.state = stateRelay.asObservable()
        self.transition = transition ?? { (_, nextState) in return nextState }
    }

}

class DemoState {

    enum State {
        case initial
        case selectToAccount
        case selectedToAccount(String)
        case selectFromAccount
        case selectedFromAccount(String)
        case enterAmount
        case enteredAmount(String)
        case confirm
        case confirmed
        case completed
    }

    lazy var state = StateMachineX(initialState: State.initial, transition: { [weak self] (fromState, toState) -> State? in
        switch (fromState, toState) {
        case (_, .initial):
            return .selectToAccount
        case (_, .selectedToAccount(let number)):
            self?.update(toAccount: number)
            return .selectFromAccount
        case (_, .selectedFromAccount(let number)):
            self?.update(fromAccount: number)
            return .enterAmount
        case (_, .enteredAmount(let value)):
            self?.update(amount: value)
            return .confirm
        case (.confirm, .confirmed):
            return .completed
        default:
            return nil
        }
    })

    func update(toAccount: String) {}
    func update(fromAccount: String) {}
    func update(amount: String) {}

}
