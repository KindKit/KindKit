//
//  KindKit
//

#if os(iOS)

import UIKit

public extension InputToolbarView {
    
    final class SpaceItem : IInputToolbarItem {
        
        public let barItem: UIBarButtonItem
        
        public init() {
            self.barItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        public init(
            width: Double
        ) {
            self.barItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            self.barItem.width = CGFloat(width)
        }
        
        public func pressed() {
        }
        
    }
    
}

public extension InputToolbarView.SpaceItem {

    @inlinable
    static func flexible() -> Self {
        return .init()
    }
    
    @inlinable
    static func fixed(_ width: Double) -> Self {
        return .init(width: width)
    }
    
}

#endif
