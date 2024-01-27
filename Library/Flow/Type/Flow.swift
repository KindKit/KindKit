//
//  KindKit
//

import KindCore
import KindEvent

public final class Flow< Input : ResultTrait, Output : ResultTrait > : FlowTrait {
    
    public typealias Input = Input
    public typealias Output = Output
    
    public var onReceive: Signal< Void, State< Output > > {
        return self._tail.onReceive
    }
    
    private let _head: Pipe
    private let _tail: Tail
    
    init< Tail : Operator >(
        head: Pipe,
        tail: Tail
    ) where Tail.Output == Output {
        self._head = head
        self._tail = .init(tail)
    }
    
    public func send(_ state: State< Input >) {
        self._head.send(state)
    }
    
}
