//
//  KindKit
//

import Foundation

public extension UI.Layout {
    
    final class Item {
        
        public var frame: RectFloat
        public let view: IUIView
        public private(set) var isNeedForceUpdate: Bool
        
        public init(_ view: IUIView) {
            self.frame = .zero
            self.view = view
            self.isNeedForceUpdate = false
            
            self.view.appearedItem = self
        }
        
    }
    
}

extension UI.Layout.Item : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Layout.Item : Equatable {
    
    public static func == (lhs: UI.Layout.Item, rhs: UI.Layout.Item) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}

public extension UI.Layout.Item {
    
    @inlinable
    var isLoaded: Bool {
        return self.view.isLoaded
    }
    
    @inlinable
    var isAppeared: Bool {
        return self.view.isAppeared
    }
    
    @inlinable
    var isHidden: Bool {
        return self.view.isHidden
    }
    
    func setNeedForceUpdate() {
        self.isNeedForceUpdate = true
    }
    
    func resetNeedForceUpdate() {
        self.isNeedForceUpdate = false
    }
    
    @inlinable
    func size(available: SizeFloat) -> SizeFloat {
        return self.view.size(available: available)
    }
    
}
