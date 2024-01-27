//
//  KindKit
//

public struct LazyItem< Item : LazyTrait > {
    
    public unowned(unsafe) let owner: Item.Owner
    
    private var _content: Item.Content!
    
    public init(_ owner: Item.Owner) {
        self.owner = owner
    }
    
}

public extension LazyItem {
    
    var isLoaded: Bool {
        return self._content != nil
    }
    
    var content: Item.Content {
        mutating get {
            if self._content == nil {
                let item = Item.create(owner: self.owner)
                self._content = item
            }
            return self._content
        }
    }
    
    mutating func unload() {
        if let content = self._content {
            self._content = nil
            Item.cleanup(owner: self.owner, content: content)
        }
    }

}
