//
//  KindKit
//

import KindCore

public enum State< Result : ResultTrait > {
    
    case result(Swift.Result< Result.Success, Result.Failure >)
    case control(Control)
    
}

public extension State {
    
    @inlinable
    static func success(_ value: Result.Success) -> Self {
        return .result(.success(value))
    }
    
    @inlinable
    static func failure(_ error: Result.Failure) -> Self {
        return .result(.failure(error))
    }
    
    @inlinable
    static var completed: Self {
        return .control(.completed)
    }
    
    @inlinable
    static var canceled: Self {
        return .control(.canceled)
    }
    
}

public extension State {
    
    @inlinable
    var success: Result.Success? {
        guard case .result(let result) = self else { return nil }
        return result.success
    }
    
    @inlinable
    var failure: Result.Failure? {
        guard case .result(let result) = self else { return nil }
        return result.failure
    }
    
    @inlinable
    var isCompleted: Bool {
        guard case .control(let control) = self else { return false }
        return control.isCompleted
    }
    
    @inlinable
    var isCanceled: Bool {
        guard case .control(let control) = self else { return false }
        return control.isCanceled
    }
    
}

extension State : Equatable where Result.Success : Equatable, Result.Failure : Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.result(let lhs), .result(let rhs)): return lhs == rhs
        case (.control(let lhs), .control(let rhs)): return lhs == rhs
        default: return false
        }
    }
    
}

extension State : Sendable where Result.Success : Sendable, Result.Failure : Sendable {
}
