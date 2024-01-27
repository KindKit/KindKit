//
//  KindKit
//

import KindCore
import KindTime

public final class Manager {
    
    private var _actions: [IAction]
    private var _displayLink: DisplayLink?
    
    init() {
        self._actions = []
    }
    
    deinit {
        self._displayLink = nil
    }
    
}

public extension Manager {
    
    @inlinable
    @discardableResult
    func run(_ action: IAction) -> ICancellable {
        self.append(action)
        return action
    }
    
    func append(_ action: IAction) {
        guard self._actions.contains(where: { $0 === action }) == false else { return }
        self._actions.append(action)
        if self._displayLink == nil {
            self._displayLink = .init(manager: self)
        }
    }
    
    func remove(_ action: IAction) {
        guard let index = self._actions.firstIndex(where: { $0 === action }) else { return }
        self._actions.remove(at: index)
        action.cancel()
    }
    
}

extension Manager {
    
    func update(_ interval: SecondsInterval) {
        var removing: [IAction] = []
        for action in self._actions {
            switch action.update(interval) {
            case .working:
                break
            case .completed:
                removing.append(action)
            }
        }
        if removing.count > 0 {
            self._actions.removeAll(where: { action in
                return removing.contains(where: { return action === $0 })
            })
        }
        if self._actions.count == 0 {
            self._displayLink = nil
        }
    }
    
}
