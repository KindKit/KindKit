//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindEvent
import KindLayout

public final class EmptyLayoutItem : ILayoutItem {
    
    public unowned(unsafe) var layout: (any ILayout)?
    
    public var isLoaded: Bool {
        return false
    }

    public var handle: NativeView {
        fatalError()
    }
    
    public var position: Position?
    
    public var frame: Rect = .zero
    
    public var isHidden: Bool = true
    
    public var isLocked: Bool = false
    
    public let onAppear = Signal< Void, Bool >()
    
    public let onDisappear = Signal< Void, Void >()
    
    public init() {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return .zero
    }
    
}
