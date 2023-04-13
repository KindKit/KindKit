//
//  KindKit
//

import Foundation

public extension UI.Reuse {

    struct Item< Reusable : IUIReusable > {
        
        unowned let owner: Reusable.Owner
        public var unloadBehaviour: UI.Reuse.UnloadBehaviour
        public var cache: UI.Reuse.Cache?
        public var name: String?
        
        private var _content: Reusable.Content!
        
        public init(
            owner: Reusable.Owner,
            unloadBehaviour: UI.Reuse.UnloadBehaviour = .whenDisappear,
            cache: UI.Reuse.Cache? = UI.Reuse.Cache.shared,
            name: String? = nil
        ) {
            self.owner = owner
            self.unloadBehaviour = unloadBehaviour
            self.cache = cache
            self.name = name
        }
        
    }
    
}

public extension UI.Reuse.Item {
    
    var isLoaded: Bool {
        return self._content != nil
    }
    
    var content: Reusable.Content {
        mutating get {
            self.loadIfNeeded()
            return self._content
        }
    }
    
}

public extension UI.Reuse.Item {
    
    mutating func loadIfNeeded() {
        if self._content == nil {
            if let cache = self.cache {
                self._content = cache.get(Reusable.self, name: self.name, owner: self.owner)
            } else {
                let item = Reusable.createReuse(owner: self.owner)
                Reusable.configureReuse(owner: self.owner, content: item)
                self._content = item
            }
        }
    }
    
    mutating func destroy() {
        self._unload()
    }
    
    mutating func disappear() {
        if self.unloadBehaviour == .whenDisappear {
            self._unload()
        }
    }

}

private extension UI.Reuse.Item {
    
    @inline(__always)
    mutating func _unload() {
        if let content = self._content {
            self._content = nil
            if let cache = self.cache {
                cache.set(Reusable.self, name: self.name, content: content)
            } else {
                Reusable.cleanupReuse(content: content)
            }
        }
    }
    
}
