//
//  KindKitUndoRedo
//

import Foundation
import KindKitObserver

public class UndoRedo {
    
    public unowned var delegate: IUndoRedoDelegate
    public private(set) var isEnabled: Bool
    public var isTracking: Bool {
        return self._scope != nil
    }
    
    private var _undoStack: [UndoRedo.Scope]
    private var _redoStack: [UndoRedo.Scope]
    private var _scope: UndoRedo.Scope?
    private var _observer: Observer< IUndoRedoObserver >
    
    public init(
        delegate: IUndoRedoDelegate
    ) {
        self.delegate = delegate
        self.isEnabled = true
        self._undoStack = []
        self._redoStack = []
        self._observer = Observer()
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
    
    func add(observer: IUndoRedoObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    func remove(observer: IUndoRedoObserver) {
        self._observer.remove(observer)
    }
    
    func undo() {
        guard self.canUndo == true else { return }
        let scope = self._undoStack.removeLast()
        self._redoStack.append(scope)
        scope.undo(self.delegate)
        self._notifyRefresh()
    }
    
    func redo() {
        guard self.canRedo == true else { return }
        let scope = self._redoStack.removeLast()
        self._undoStack.append(scope)
        scope.redo(self.delegate)
        self._notifyRefresh()
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
            self._notifyRefresh()
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
    
    func track<
        Command : RawRepresentable
    >(
        create command: Command,
        object: String,
        _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void
    ) where Command.RawValue == String {
        guard let scope = self._scope else { return }
        scope.create(command.rawValue, object, closure)
    }
    
    func track<
        Command : RawRepresentable
    >(
        update command: Command,
        object: String,
        _ closure: (_ context: inout IUndoRedoMutatingTransformContext) -> Void
    ) where Command.RawValue == String {
        guard let scope = self._scope else { return }
        scope.update(command.rawValue, object, closure)
    }
    
    func track<
        Command : RawRepresentable
    >(
        delete command: Command,
        object: String,
        _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void
    ) where Command.RawValue == String {
        guard let scope = self._scope else { return }
        scope.delete(command.rawValue, object, closure)
    }
    
}

private extension UndoRedo {
    
    func _notifyRefresh() {
        self._observer.notify({ $0.refresh(self) })
    }
        
}
