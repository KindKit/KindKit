//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class CompactMap< Input : IFlowResult, Success, Failure : Swift.Error > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Failure >
        
        private let _function: (Result< Input.Success, Input.Failure >) -> Output?
        private var _next: IFlowPipe!
        
        init(
            _ function: @escaping (Result< Input.Success, Input.Failure >) -> Output?
        ) {
            self._function = function
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._receive(.success(value))
        }
        
        public func receive(error: Input.Failure) {
            self._receive(.failure(error))
        }
        
        public func completed() {
            self._next.completed()
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.CompactMap {
    
    func _receive(_ input: Result< Input.Success, Input.Failure >) {
        switch self._function(input) {
        case .success(let value):
            self._next.send(value: value)
        case .failure(let error):
            self._next.send(error: error)
        case .none:
            break
        }
    }
    
}

public extension IFlowBuilder {
    
    func compactMap<
        Success,
        Failure : Swift.Error
    >(
        _ function: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Result< Success, Failure >?
    ) -> Flow.Chain< Head, Flow.Operator.CompactMap< Tail.Output, Success, Failure > > {
        return self.append(.init(function))
    }
    
    func compactMap<
        Success,
        Failure : Swift.Error
    >(
        value function: @escaping (Tail.Output.Success) -> Result< Success, Failure >?
    ) -> Flow.Chain< Head, Flow.Operator.CompactMap< Tail.Output, Success, Failure > > where Tail.Output.Failure == Never {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return function(value)
            case .failure: return nil
            }
        }))
    }
    
    func compactMap<
        Success
    >(
        value function: @escaping (Tail.Output.Success) -> Success?
    ) -> Flow.Chain< Head, Flow.Operator.CompactMap< Tail.Output, Success, Tail.Output.Failure > > {
        return self.append(.init({ input in
            switch input {
            case .success(let value):
                if let value = function(value) {
                    return .success(value)
                }
                return nil
            case .failure(let error):
                return .failure(error)
            }
        }))
    }
    
    func compactMap<
        Failure : Swift.Error
    >(
        error function: @escaping (Tail.Output.Failure) -> Failure?
    ) -> Flow.Chain< Head, Flow.Operator.CompactMap< Tail.Output, Tail.Output.Success, Failure > > {
        return self.append(.init({ input in
            switch input {
            case .success(let value): 
                return .success(value)
            case .failure(let error):
                if let error = function(error) {
                    return .failure(error)
                }
                return nil
            }
        }))
    }
    
}
