//
//  KindKit
//

import KindEvent
import KindMeasure

public final class ParallelAction : Action {
    
    public private(set) var state: State = .idle {
        didSet {
            switch self.state {
            case .idle:
                break
            case .working:
                self.onStart.emit()
            case .completed:
                self.onFinish.emit(true)
            case .canceled:
                self.onFinish.emit(false)
            }
        }
    }
    
    public let actions: [Action]
    
    public let onStart = Signal< Void, Void >()
    
    public let onFinish = Signal< Void, Bool >()
    
    private var _completed = Set< Int >()

    public init(_ actions: [Action]) {
        self.actions = actions
    }
    
    public convenience init(@ActionsBuilder builder: () -> [Action]) {
        self.init(builder())
    }
    
    public func update(_ interval: Time) -> Result {
        switch self.state {
        case .idle:
            self.state = .working
            fallthrough
        case .working:
            var interval = interval
            for index in 0 ..< self.actions.count {
                guard self._completed.contains(index) == false else {
                    continue
                }
                let action = self.actions[index]
                switch action.update(interval) {
                case .working:
                    break
                case .completed(let remainder):
                    self._completed.insert(index)
                    interval = remainder
                }
            }
            if self.actions.count == self._completed.count {
                self.state = .completed
                return .completed(interval)
            }
            return .working
        case .completed, .canceled:
            return .completed(interval)
        }
    }
    
    public func cancel() {
        switch self.state {
        case .idle, .working:
            self.state = .canceled
            for action in self.actions {
                action.cancel()
            }
        case .completed, .canceled:
            break
        }
    }

}
