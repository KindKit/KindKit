//
//  FloorPlanDescription
//

import Foundation

extension UndoRedo.Context {
    
    struct Permanent : IUndoRedoMutatingPermanentContext {
        
        var command: String
        var keys: [String] {
            return Array(self._data.keys)
        }
        
        private var _data: [String : Any]
        
        init(
            command: String,
            data: [String : Any] = [:]
        ) {
            self.command = command
            self._data = data
        }
        
        func get(_ key: String) -> Any? {
            return self._data[key]
        }
        
        mutating func set(_ key: String, value: Any?) {
            self._data[key] = value
        }
        
        func cleanup() {
        }
        
    }
    
}
