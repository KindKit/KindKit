//
//  KindKit
//

enum State : Equatable {
    
    case paused
    case running
    case executing
    case finished

}

extension State {
    
    @inlinable
    var isRunning: Bool {
        return self == .running || self == .executing
    }
    
    @inlinable
    var isExecuting: Bool {
        return self == .executing
    }
    
    @inlinable
    var isFinished: Bool {
        return self == .finished
    }
    
}
