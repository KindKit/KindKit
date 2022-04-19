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
        for state in scope.deleted {
            self.delegate.create(context: state)
        }
        for state in scope.updated.reversed() {
            self.delegate.update(context: state.old)
        }
        for state in scope.created {
            self.delegate.delete(context: state)
        }
        self._notifyRefresh()
    }
    
    func redo() {
        guard self.canRedo == true else { return }
        let scope = self._redoStack.removeLast()
        self._undoStack.append(scope)
        for state in scope.created {
            self.delegate.create(context: state)
        }
        for state in scope.updated {
            self.delegate.update(context: state.new)
        }
        for state in scope.deleted {
            self.delegate.delete(context: state)
        }
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
        guard self.isTracking == true else { return }
        if self._scope!.isValid == true && cancel == false {
            self._undoStack.append(self._scope!)
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
    
    func track< CommandType: RawRepresentable >(create command: CommandType, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) where CommandType.RawValue == String {
        guard self._scope != nil else { return }
        self._scope!.create(command.rawValue, closure)
    }
    
    func track< CommandType: RawRepresentable >(update command: CommandType, _ closure: (_ context: inout IUndoRedoMutatingTransformContext) -> Void) where CommandType.RawValue == String {
        guard self._scope != nil else { return }
        self._scope!.update(command.rawValue, closure)
    }
    
    func track< CommandType: RawRepresentable >(delete command: CommandType, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) where CommandType.RawValue == String {
        guard self._scope != nil else { return }
        self._scope!.delete(command.rawValue, closure)
    }
    
}

private extension UndoRedo {
    
    func _notifyRefresh() {
        self._observer.notify({ $0.refresh(self) })
    }
        
}
