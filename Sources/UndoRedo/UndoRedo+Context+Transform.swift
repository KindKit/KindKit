//
//  FloorPlanDescription
//

import Foundation

extension UndoRedo.Context {
    
    struct Transform : IUndoRedoMutatingTransformContext {
        
        var command: String
        var keys: [String] {
            return Array(self._new.keys)
        }
        var old: IUndoRedoPermanentContext {
            return UndoRedo.Context.Permanent(command: self.command, data: self._old)
        }
        var new: IUndoRedoPermanentContext {
            return UndoRedo.Context.Permanent(command: self.command, data: self._new)
        }
        
        private var _old: [String : Any]
        private var _new: [String : Any]
        
        init(command: String) {
            self.command = command
            self._old = [:]
            self._new = [:]
        }
        
        func old(_ key: String) -> Any? {
            return self._old[key]
        }
        
        func new(_ key: String) -> Any? {
            return self._new[key]
        }
        
        mutating func set(_ key: String, new: Any?, old: Any?) {
            if self._old[key] == nil {
                self._old[key] = old
            }
            self._new[key] = new
        }
        
        func cleanup() {
        }
        
    }
    
}
