//
//  Dismissable.swift
//  Dismissible
//
//  Created by Michael Long on 3/6/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum DismissibleAction {
    case dismiss
    case pop
    case root
    case none
}

public typealias DismissibleSubscription<ReturnType> = (_ value: ReturnType) -> Void

public final class DismissibleSubject<ReturnType>: NSObject {

    /// Provide a public dispose bag so that any subscriptions to our observable can be properly disposed of when our view controller and its
    /// dismissible is deallocated.
    public var bag = DisposeBag()

    // Lifcycle
    public init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    /// Returns dismissible's internal subject on MainScheduler.instance as a non-mutable observable
    public func asObservable() -> Observable<ReturnType> {
        #if DEBUG
        observed = true
        #endif
        return subject.asObservable()
            .observeOn(MainScheduler.instance)
    }

    /// Setup automatic pop or dismiss subscription.
    ///
    /// Note that any subscription based on this observable should use this dismissible's built-in DisposeBag.
    ///
    /// Sample Code
    ///    ````
    ///    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    ///        if let viewContoller = segue.destination as? SelectionViewController {
    ///            viewContoller.dismissible
    ///                .onDismiss(perform: .pop)
    ///                .subscribe(onNext: { result in
    ///                    self.viewModel.selectedId = result
    ///                })
    ///                .disposed(by: viewContoller.dismissible.bag)
    ///        }
    ///    }
    ///    ````
    ///
    /// - Parameter action: Specifies .pop or .dismiss operation to be performed when subject completes.
    ///
    /// - Returns: Observable of ReturnType
    public func onDismiss(perform action: DismissibleAction = .none) -> Observable<ReturnType> {
        self.asObservable()
            .subscribe({ [weak self] event in
                if let viewController = self?.viewController, event.isStopEvent {
                    self?.perform(action, using: viewController)
                }
            })
            .disposed(by: bag)
        // convenience return
        return asObservable()
    }

    /// Setup automatic pop or dismiss with built-in subscription handler.
    ///
    /// The subscription will automatically be disposed by dismissible's built-in DisposeBag when the dismissible is deallocated.
    ///
    /// Sample Code
    ///    ````
    ///    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    ///        if let viewContoller = segue.destination as? SelectionViewController {
    ///            viewContoller.dismissible
    ///                .onDismiss(perform: .pop) { result in
    ///                    self.viewModel.selectedId = result
    ///                })
    ///        }
    ///    }
    ///    ````
    ///
    /// - Parameter action: Specifies .pop or .dismiss operation to be performed when subject completes.
    /// - Parameter subscribe: Closure block to be called when dismissible is dismissed.
    /// - Parameter value: Passed to closure by dismiss(returning:).
    ///
    /// - Returns: Void
    public func onDismiss(perform action: DismissibleAction = .none, subscribe: @escaping DismissibleSubscription<ReturnType>) {
        self.asObservable()
            .subscribe({ [weak self] event in
                if let viewController = self?.viewController {
                    switch event {
                    case .next(let element):
                        subscribe(element)
                    case .completed, .error:
                        self?.perform(action, using: viewController)
                    }
                }
            })
            .disposed(by: bag)
    }

    /// Done with viewController, so dismiss and returnining value.
    public func dismiss(returning value: ReturnType) {
        #if DEBUG
        checkObservedStatus()
        #endif
        subject.onNext(value)
        subject.onCompleted() // ensure we call completed so view controllers are properly dismissed
    }

    /// Done with viewController, so dismiss returning an error.
    public func dismiss(with error: Error) {
        #if DEBUG
        checkObservedStatus()
        #endif
        subject.onError(error)
    }

    /// Done with viewController and not returning a value, so just complete.
    public func dismiss() {
        #if DEBUG
        checkObservedStatus()
        #endif
        subject.onCompleted()
    }

    // Internal support

    internal func perform(_ action: DismissibleAction, using viewController: UIViewController) {
        guard dismissed == false else {
            return
        }
        dismissed = true
        switch action {
        case .dismiss:
            viewController.dismiss(animated: true, completion: nil)
        case .pop:
            // popToViewController ensures that anything pushed on top of us is also released
            viewController.navigationController?.popToViewController(viewController, animated: false)
            // now it's our turn
            viewController.navigationController?.popViewController(animated: true)
        case .root:
            viewController.navigationController?.popToRootViewController(animated: true)
        default:
            break
        }
    }

    #if DEBUG
    private var observed = false
    internal func checkObservedStatus() {
        if observed == false {
            print("WARNING: Dismissible was dismissed but was not observed.")
        }
    }
    #endif

    private weak var viewController: UIViewController?
    private let subject = PublishSubject<ReturnType>()
    private var dismissed = false
}

public struct DismissibleSubjectReactiveBase<ReturnType> {

    weak var base: DismissibleSubject<ReturnType>!

    init(_ base: DismissibleSubject<ReturnType>) {
        self.base = base
    }

    public var dimsissReturningValue: Binder<ReturnType> {
        return Binder<ReturnType>(base, binding: { (base, value) in
            base.dismiss(returning: value)
        })
    }

    public var dimsiss: Binder<Void> {
        return Binder<Void>(base, binding: { (base, _) in
            base.dismiss()
        })
    }

}
