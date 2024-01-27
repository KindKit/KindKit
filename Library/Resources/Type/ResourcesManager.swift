//
//  KindKit
//

import KindCore
import KindEvent
import KindSystem

public final class ResourcesManager {
    
    private var _items: [String : any IResource] = [:]
    
    private let _lock = RecursiveLock()
    
    fileprivate init() {
        AppState.default.add(observer: self, priority: .internal)
    }
    
    deinit {
        AppState.default.remove(observer: self)
    }
    
}

public extension ResourcesManager {
    
    static let shared = ResourcesManager()
    
}

public extension ResourcesManager {
    
    func append< Resource : IResource >(_ resource: Resource) {
        self._lock.perform({
            let key = resource.key
            if let resource = self._items[key] {
                resource.destroy()
            }
            self._items[key] = resource
        })
    }
    
    func remove< Resource : IResource >(_ resource: Resource) {
        self._lock.perform({
            let key = resource.key
            if let resource = self._items[key] {
                resource.destroy()
            }
            self._items[key] = nil
        })
    }
    
}

fileprivate extension ResourcesManager {
    
}

fileprivate extension IResource {
    
    var key: String {
        return "\(self.category.raw)_\(self.id.raw)"
    }
    
}
