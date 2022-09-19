//
//  KindKit
//

import Foundation

public extension UI.Reuse {

    struct Item< Reusable : IUIReusable > {
        
        var unloadBehaviour: UI.Reuse.UnloadBehaviour
        let name: String?
        
        private unowned var _owner: Reusable.Owner!
        private var _content: Reusable.Content?
        
        public init(
            unloadBehaviour: UI.Reuse.UnloadBehaviour = .whenDisappear,
            name: String? = nil
        ) {
            self.unloadBehaviour = unloadBehaviour
            self.name = name
        }
        
    }
    
}

public extension UI.Reuse.Item {
    
    var isLoaded: Bool {
        return self._content != nil
    }
    
    mutating func configure(owner: Reusable.Owner) {
        self._owner = owner
    }
    
    mutating func loadIfNeeded() {
        if self._content == nil {
            self._content = UI.Reuse.Cache.shared.get(Reusable.self, name: self.name, owner: self._owner)
        }
    }
    
    mutating func content() -> Reusable.Content {
        self.loadIfNeeded()
        return self._content!
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
            UI.Reuse.Cache.shared.set(Reusable.self, name: self.name, content: content)
        }
    }
    
}
