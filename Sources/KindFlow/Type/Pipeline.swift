//
//  KindKit
//

import Foundation

public final class Pipeline< Input : IResult, Output : IResult > : IPipeline {
    
    public typealias Input = Input
    public typealias Output = Output
    public typealias Result = Swift.Result< Output.Success, Output.Failure >
    
    private var _subscriptions: [Subscription< Input, Output >]
    private let _head: IPipe
    private let _tail: Tail< Input, Output >
    
    init< TailType : IOperator >(
        head: IPipe,
        tail: TailType
    ) where TailType.Output == Output {
        self._subscriptions = []
        self._head = head
        self._tail = Tail(tail)
        self._tail.pipeline = self
    }
    
    deinit {
        self._tail.pipeline = nil
        for subscription in self._subscriptions {
            subscription.pipeline = nil
        }
    }
    
    public func subscribe(
        onReceiveValue: @escaping (Output.Success) -> Void = { _ in },
        onReceiveError: @escaping (Output.Failure) -> Void = { _ in },
        onCompleted: (() -> Void)?
    ) -> ISubscription {
        let subscription = Subscription(
            pipeline: self,
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
        self._subscriptions.append(subscription)
        return subscription
    }
    
    public func send(value: Input.Success) {
        self._head.send(value: value)
    }
    
    public func send(error: Input.Failure) {
        self._head.send(error: error)
    }
    
    public func completed() {
        self._head.completed()
    }
    
    public func cancel() {
        self._head.cancel()
    }
    
}

extension Pipeline {
    
    func unsubscribe(_ subscription: ISubscription) {
        guard let index = self._subscriptions.firstIndex(where: { $0 === subscription }) else { return }
        self._subscriptions.remove(at: index)
    }
    
    func tailReceive(value: Output.Success) {
        for subscription in self._subscriptions {
            subscription.receive(value: value)
        }
    }
    
    func tailReceive(error: Output.Failure) {
        for subscription in self._subscriptions {
            subscription.receive(error: error)
        }
    }
    
    func tailCompleted() {
        for subscription in self._subscriptions {
            subscription.completed()
        }
    }
    
}
