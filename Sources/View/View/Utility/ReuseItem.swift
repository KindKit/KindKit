//
//  KindKitView
//

import Foundation

public enum ReuseItemBehaviour {
    case unloadWhenDestroy
    case unloadWhenDisappear
}

public struct ReuseItem< Reusable : IReusable > {
    
    private let _behaviour: ReuseItemBehaviour
    private let _name: String?
    private unowned var _owner: Reusable.Owner!
    private var _content: Reusable.Content?
    
    public init(
        behaviour: ReuseItemBehaviour = .unloadWhenDisappear,
        name: String? = nil
    ) {
        self._behaviour = behaviour
        self._name = name
    }
    
}

public extension ReuseItem {
    
    var isLoaded: Bool {
        return self._content != nil
    }
    
    mutating func configure(owner: Reusable.Owner) {
        self._owner = owner
    }
    
    mutating func loadIfNeeded() {
        if self._content == nil {
            self._content = ReuseCache.shared.get(Reusable.self, name: self._name, owner: self._owner)
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
        if self._behaviour == .unloadWhenDisappear {
            self._unload()
        }
    }

}

private extension ReuseItem {
    
    @inline(__always)
    mutating func _unload() {
        if let content = self._content {
            self._content = nil
            ReuseCache.shared.set(Reusable.self, name: self._name, content: content)
        }
    }
    
}
