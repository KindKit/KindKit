//
//  KindKit
//

struct TransformContext : IMutatingTransformContext {
    
    var command: String
    var object: String
    var keys: [String] {
        return .init(self._new.keys)
    }
    var old: IPermanentContext {
        return PermanentContext(self.command, self.object, self._old)
    }
    var new: IPermanentContext {
        return PermanentContext(self.command, self.object, self._new)
    }
    
    private var _old: [String : Any]
    private var _new: [String : Any]
    
    init(
        _ command: String,
        _ object: String
    ) {
        self.command = command
        self.object = object
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
