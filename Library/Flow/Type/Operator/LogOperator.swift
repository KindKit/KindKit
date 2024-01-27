//
//  KindKit
//


import KindCore
import KindLog

public final class LogOperator< Input : ResultTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Input
    public typealias Message = @Sendable (InputState) -> KindLog.Message?
    
    private let _message: Message
    private var _next: (any Pipe)!
    
    init(
        _ message: @escaping Message
    ) {
        self._message = message
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        if let message = self._message(state) {
            KindLog.log(message)
        }
        self._next.send(state)
    }
    
}

extension LogOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func log(
        _ message: @escaping @Sendable (Tail.OutputState) -> KindLog.Message?
    ) -> BuilderChain< Head, LogOperator< Tail.Output > > {
        return self.append(.init(message))
    }
    
    func log(
        _ message: @escaping @Sendable (Tail.OutputResult) -> KindLog.Message?
    ) -> BuilderChain< Head, LogOperator< Tail.Output > > {
        return self.append(.init({
            switch $0 {
            case .result(let result): return message(result)
            case .control: return nil
            }
        }))
    }
    
    func log(
        value message: @escaping @Sendable (Tail.Output.Success) -> KindLog.Message?
    ) -> BuilderChain< Head, LogOperator< Tail.Output > > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success(let value): return message(value)
                case .failure: return nil
                }
            case .control: return nil
            }
        }))
    }
    
    func log(
        error message: @escaping @Sendable (Tail.Output.Failure) -> KindLog.Message?
    ) -> BuilderChain< Head, LogOperator< Tail.Output > > {
        return self.append(.init({
            switch $0 {
            case .result(let result):
                switch result {
                case .success: return nil
                case .failure(let error): return message(error)
                }
            case .control: return nil
            }
        }))
    }
    
}
