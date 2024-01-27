//
//  KindKit
//

import KindEvent
import KindMath
import KindTime
import KindMonadicMacro

@KindMonadic
public final class SequenceAction : IAction {
    
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
    
    public let actions: [IAction]
    
    public let onStart = Signal< Void, Void >()
    
    public let onFinish = Signal< Void, Bool >()
    
    private var _current: Int

    public init(_ actions: [IAction]) {
        self._current = actions.startIndex
        self.actions = actions
    }
    
    public convenience init(@Builder builder: () -> [IAction]) {
        self.init(builder())
    }
    
    public func update(_ interval: SecondsInterval) -> Result {
        switch self.state {
        case .idle:
            self.state = .working
            fallthrough
        case .working:
            var interval = interval
            if self._current < self.actions.count {
                var working = true
                while working == true {
                    let action = self.actions[self._current]
                    switch action.update(interval) {
                    case .working:
                        working = false
                    case .completed(let remainder):
                        self._current += 1
                        working = self._current < self.actions.count
                        interval = remainder
                    }
                }
            }
            if self._current >= self.actions.count {
                self.state = .completed
                return .completed(interval)
            }
            return .working
        case .completed, .canceled:
            return .completed(interval)
        }
    }
    
    public func complete() {
        switch self.state {
        case .idle, .working:
            self.state = .completed
        case .completed, .canceled:
            break
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
