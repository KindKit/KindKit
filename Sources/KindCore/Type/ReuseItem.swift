//
//  KindKit
//

public struct ReuseItem< ItemType : IReusable > {
    
    public unowned(unsafe) let owner: ItemType.Owner
    public var unloadBehaviour: ReuseUnloadBehaviour = .whenDisappear
    public var cache: ReuseCache? = ReuseCache.default
    
    private var _content: ItemType.Content!
    
    public init(_ owner: ItemType.Owner) {
        self.owner = owner
    }
    
}

public extension ReuseItem {
    
    var isLoaded: Bool {
        return self._content != nil
    }
    
    var content: ItemType.Content {
        mutating get {
            if self._content == nil {
                if let cache = self.cache {
                    self._content = cache.get(ItemType.self, owner: self.owner)
                } else {
                    let item = ItemType.create(owner: self.owner)
                    ItemType.configure(owner: self.owner, content: item)
                    self._content = item
                }
            }
            return self._content
        }
    }
    
    mutating func disappear() {
        if self.unloadBehaviour == .whenDisappear {
            self.unload()
        }
    }
    
    mutating func unload() {
        if let content = self._content {
            self._content = nil
            if let cache = self.cache {
                cache.set(ItemType.self, owner: self.owner, content: content)
            } else {
                ItemType.cleanup(owner: self.owner, content: content)
            }
        }
    }

}
