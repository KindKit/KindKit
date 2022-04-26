//
//  KindKitUndoRedo
//

import Foundation

extension UndoRedo {
    
    class Scope : IUndoRedoScope {
        
        var isValid: Bool {
            return self._states.isEmpty == false
        }
        private var _states: [IUndoRedoState]

        init() {
            self._states = []
        }
        
        func create(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) {
            let appended: Bool
            if let state = self._states.last {
                appended = state.create(command, object, closure)
            } else {
                appended = false
            }
            if appended == false {
                self._states.append(UndoRedo.State.Create(command, object, closure))
            }
        }
        
        func update(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingTransformContext) -> Void) {
            let appended: Bool
            if let state = self._states.last {
                appended = state.update(command, object, closure)
            } else {
                appended = false
            }
            if appended == false {
                self._states.append(UndoRedo.State.Update(command, object, closure))
            }
        }
        
        func delete(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) {
            let appended: Bool
            if let state = self._states.last {
                appended = state.delete(command, object, closure)
            } else {
                appended = false
            }
            if appended == false {
                self._states.append(UndoRedo.State.Delete(command, object, closure))
            }
        }
        
        func undo(_ delegate: IUndoRedoDelegate) {
            for state in self._states.reversed() {
                state.undo(delegate)
            }
        }
        
        func redo(_ delegate: IUndoRedoDelegate) {
            for state in self._states {
                state.redo(delegate)
            }
        }
        
        func cleanup() {
            for state in self._states {
                state.cleanup()
            }
        }
        
    }
    
}
