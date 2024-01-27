//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindLayout

public final class LayoutHolder : IHolder {
    
    public unowned(unsafe) var container: NativeView
    
    public var childs: [NativeView] {
        return self.container.subviews
    }
    
    public init(_ container: NativeView) {
        self.container = container
    }
    
    public func insert(_ item: any IItem, at index: Int) {
        guard let item = item as? (any ILayoutItem) else { return }
        let handle = item.handle
        let childs = self.childs
        if index < childs.count {
            if handle.superview != self.container {
                self._insert(handle, at: index)
            } else if handle !== childs[index] {
                self._insert(handle, at: index)
            }
        } else if handle.superview != self.container {
            self._append(handle)
        }
    }
    
    public func remove(_ item: any IItem) {
        guard let item = item as? (any ILayoutItem) else { return }
        item.handle.removeFromSuperview()
    }
    
}

fileprivate extension LayoutHolder {
    
    final func _append(_ handle: NativeView) {
#if os(macOS)
        self.container.addSubview(handle)
#elseif os(iOS)
        self.container.addSubview(handle)
#endif
    }
    
    final func _insert(_ handle: NativeView, at index: Int) {
#if os(macOS)
        self.container.addSubview(handle, positioned: .below, relativeTo: self.childs[index])
#elseif os(iOS)
        self.container.insertSubview(handle, at: index)
#endif
    }
    
}
