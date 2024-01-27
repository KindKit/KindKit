//
//  KindKit
//

public struct ReuseItem< Item : ReuseTrait > : Sendable {
    
    public unowned(unsafe) let owner: Item.Owner
    public var unloadBehaviour: ReuseUnloadBehaviour = .whenDisappear
    public var cache: ReuseCache? = ReuseCache.default
    
    private var _content: Item.Content!
    
    public init(_ owner: Item.Owner) {
        self.owner = owner
    }
    
}

public extension ReuseItem {
    
    var isLoaded: Bool {
        return self._content != nil
    }
    
    var content: Item.Content {
        mutating get {
            if self._content == nil {
                if let cache = self.cache {
                    self._content = cache.get(Item.self, owner: self.owner)
                } else {
                    let item = Item.create(owner: self.owner)
                    Item.configure(owner: self.owner, content: item)
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
                cache.set(Item.self, owner: self.owner, content: content)
            } else {
                Item.cleanup(owner: self.owner, content: content)
            }
        }
    }

}
