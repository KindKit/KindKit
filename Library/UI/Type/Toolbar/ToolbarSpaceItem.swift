//
//  KindKit
//

#if os(iOS)

import UIKit

public final class ToolbarSpaceItem : IToolbarItem {
    
    public let handle: UIBarButtonItem
    
    public init() {
        self.handle = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    public init(
        width: Double
    ) {
        self.handle = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        self.handle.width = CGFloat(width)
    }
    
    public func pressed() {
    }
    
}

public extension ToolbarSpaceItem {

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
