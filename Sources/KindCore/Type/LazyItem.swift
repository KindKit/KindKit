//
//  KindKit
//

public struct LazyItem< ItemType : ILazyable > {
    
    public unowned(unsafe) let owner: ItemType.Owner
    
    private var _content: ItemType.Content!
    
    public init(_ owner: ItemType.Owner) {
        self.owner = owner
    }
    
}

public extension LazyItem {
    
    var isLoaded: Bool {
        return self._content != nil
    }
    
    var content: ItemType.Content {
        mutating get {
            if self._content == nil {
                let item = ItemType.create(owner: self.owner)
                self._content = item
            }
            return self._content
        }
    }
    
    mutating func unload() {
        if let content = self._content {
            self._content = nil
            ItemType.cleanup(owner: self.owner, content: content)
        }
    }

}
