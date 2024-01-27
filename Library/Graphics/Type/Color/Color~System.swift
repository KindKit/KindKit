//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension Color {
    
#if os(macOS)
    
    @inlinable
    static var systemLabel: Self {
        return .init(.labelColor)
    }
    
    @inlinable
    static var systemPlaceholderLabel: Self {
        return .init(.placeholderTextColor)
    }
    
    @inlinable
    static var systemFieldSelectionColor: Self {
        return .init(.selectedTextColor)
    }
    
#elseif os(iOS)
    
    @inlinable
    static var systemLabel: Self {
        return .init(.label)
    }
    
    @inlinable
    static var systemPlaceholderLabel: Self {
        return .init(.placeholderText)
    }
    
    @inlinable
    static var systemFieldSelectionColor: Self {
        return .init(.systemBlue)
    }
    
#endif
    
}
