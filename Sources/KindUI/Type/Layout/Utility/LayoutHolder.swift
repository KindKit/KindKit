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
    
    public let container: NativeView
    
    public init(_ container: NativeView) {
        self.container = container
    }
    
    public func insert(_ item: IItem, at index: Int) {
        guard let item = item as? ILayoutItem else { return }
#if os(macOS)
        let subviews = self.container.subviews
        if subviews.isEmpty == true || index >= subviews.count {
            self.container.addSubview(item.handle)
        } else {
            self.container.addSubview(item.handle, positioned: .below, relativeTo: subviews[index])
        }
#elseif os(iOS)
        self.container.insertSubview(item.handle, at: index)
#endif
    }
    
    public func remove(_ item: IItem) {
        guard let item = item as? ILayoutItem else { return }
        item.handle.removeFromSuperview()
    }
    
}
