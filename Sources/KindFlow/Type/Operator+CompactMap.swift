//
//  KindKit
//

import Foundation

public extension Operator {
    
    final class CompactMap< InputType : IResult, SuccessType, FailureType : Swift.Error > : IOperator {
        
        public typealias Input = InputType
        public typealias Output = Result< SuccessType, FailureType >
        
        private let _function: (Result< Input.Success, Input.Failure >) -> Output?
        private var _next: IPipe!
        
        init(
            _ function: @escaping (Result< Input.Success, Input.Failure >) -> Output?
        ) {
            self._function = function
        }
        
        public func subscribe(next: IPipe) {
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

private extension Operator.CompactMap {
    
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

public extension IBuilder {
    
    func compactMap<
        SuccessType,
        FailureType : Swift.Error
    >(
        _ function: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Result< SuccessType, FailureType >?
    ) -> Chain< Head, Operator.CompactMap< Tail.Output, SuccessType, FailureType > > {
        return self.append(.init(function))
    }
    
    func compactMap<
        SuccessType,
        FailureType : Swift.Error
    >(
        value function: @escaping (Tail.Output.Success) -> Result< SuccessType, FailureType >?
    ) -> Chain< Head, Operator.CompactMap< Tail.Output, SuccessType, FailureType > > where Tail.Output.Failure == Never {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return function(value)
            case .failure: return nil
            }
        }))
    }
    
    func compactMap<
        SuccessType
    >(
        value function: @escaping (Tail.Output.Success) -> SuccessType?
    ) -> Chain< Head, Operator.CompactMap< Tail.Output, SuccessType, Tail.Output.Failure > > {
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
        FailureType : Swift.Error
    >(
        error function: @escaping (Tail.Output.Failure) -> FailureType?
    ) -> Chain< Head, Operator.CompactMap< Tail.Output, Tail.Output.Success, FailureType > > {
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
