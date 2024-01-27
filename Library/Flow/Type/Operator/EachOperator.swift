//
//  KindKit
//

import KindCore

public final class EachOperator< Input : ResultTrait > : Operator where Input.Success : Swift.Sequence {
    
    public typealias Input = Input
    public typealias Output = Result< Input.Success.Element, Input.Failure >
    
    private var _next: (any Pipe)!
    
    fileprivate init() {
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            switch result {
            case .success(let value):
                for item in value {
                    self._next.send(value: item)
                }
            case .failure(let error):
                self._next.send(error: error)
            }
        case .control(let control):
            self._next.send(control)
        }
    }
    
}

extension EachOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func each() -> BuilderChain<
        Head,
        EachOperator< Tail.Output >
    > where
        Tail.Output.Success : Sequence
    {
        return self.append(.init())
    }
    
}
