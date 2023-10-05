//
//  KindKit
//

import Foundation

public final class UndoRedo {
    
    public weak var delegate: IUndoRedoDelegate?
    public private(set) var isEnabled: Bool = true
    public var isTracking: Bool {
        return self._scope != nil
    }
    public private(set) var isApplies: Bool = false
    
    public let onRefresh = Signal.Empty< Void >()
    
    private var _undoStack: [UndoRedo.Scope] = []
    private var _redoStack: [UndoRedo.Scope] = []
    private var _scope: UndoRedo.Scope?
    
    public init(
        delegate: IUndoRedoDelegate
    ) {
        self.delegate = delegate
    }
    
}

public extension UndoRedo {
    
    var canUndo: Bool {
        return self._undoStack.isEmpty == false
    }

    var canRedo: Bool {
        return self._redoStack.isEmpty == false
    }

}

public extension UndoRedo {
    
    func undo() {
        guard let delegate = self.delegate else { return }
        guard self.canUndo == true else { return }
        guard self.isApplies == false else { return }
        self.isApplies = true
        let scope = self._undoStack.removeLast()
        self._redoStack.append(scope)
        scope.undo(delegate)
        self.isApplies = false
        self.onRefresh.emit()
    }
    
    func redo() {
        guard let delegate = self.delegate else { return }
        guard self.canRedo == true else { return }
        let scope = self._redoStack.removeLast()
        self._undoStack.append(scope)
        scope.redo(delegate)
        self.onRefresh.emit()
    }
    
    func disable(_ block: () -> Void) {
        if self.isEnabled == true {
            self.isEnabled = false
            block()
            self.isEnabled = true
        } else {
            block()
        }
    }
    
    func startScope() {
        guard self.isEnabled == true && self.isTracking == false else { return }
        self._scope = UndoRedo.Scope()
    }
    
    func endScope(cancel: Bool = false) {
        guard let scope = self._scope else { return }
        if scope.isValid == true && cancel == false {
            self._undoStack.append(scope)
            if self._redoStack.isEmpty == false {
                for scope in self._redoStack {
                    scope.cleanup()
                }
                self._redoStack.removeAll()
            }
            self.onRefresh.emit()
        }
        self._scope = nil
    }
    
    func scope(_ block: () -> Void) {
        if self.isEnabled == true && self.isTracking == false {
            self.startScope()
            block()
            self.endScope()
        } else {
            block()
        }
    }
    
    func scope< Result >(_ block: () -> Result) -> Result {
        let result: Result
        if self.isEnabled == true && self.isTracking == false {
            self.startScope()
            result = block()
            self.endScope()
        } else {
            result = block()
        }
        return result
    }
    
    func track(
        create command: String,
        object: String,
        _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void
    ) {
        guard let scope = self._scope else { return }
        scope.create(command, object, closure)
    }
    
    func track<
        Command : RawRepresentable
    >(
        create command: Command,
        object: String,
        _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void
    ) where Command.RawValue == String {
        self.track(create: command.rawValue, object: object, closure)
    }
    
    func track(
        update command: String,
        object: String,
        _ closure: (inout IUndoRedoMutatingTransformContext) -> Void
    ) {
        guard let scope = self._scope else { return }
        scope.update(command, object, closure)
    }
    
    func track<
        Command : RawRepresentable
    >(
        update command: Command,
        object: String,
        _ closure: (inout IUndoRedoMutatingTransformContext) -> Void
    ) where Command.RawValue == String {
        self.track(update: command.rawValue, object: object, closure)
    }
    
    func track(
        delete command: String,
        object: String,
        _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void
    ) {
        guard let scope = self._scope else { return }
        scope.delete(command, object, closure)
    }
    
    func track<
        Command : RawRepresentable
    >(
        delete command: Command,
        object: String,
        _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void
    ) where Command.RawValue == String {
        self.track(delete: command.rawValue, object: object, closure)
    }
    
}

public extension UndoRedo {
    
    @inlinable
    @discardableResult
    func onRefresh(_ closure: (() -> Void)?) -> Self {
        self.onRefresh.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onRefresh(_ closure: @escaping (Self) -> Void) -> Self {
        self.onRefresh.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onRefresh< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onRefresh.link(sender, closure)
        return self
    }
    
}
