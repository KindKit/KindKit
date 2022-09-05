//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public struct SegmentedViewItem : Equatable {
    
    public var content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
    
}

public extension SegmentedViewItem {
    
    enum Content : Equatable {
        
        case string(String)
        case image(Image)
        
    }
    
}

public protocol ISegmentedView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable, IViewLockable {
    
    var items: [SegmentedViewItem] { set get }
    
    var selectedItem: SegmentedViewItem? { set get }
    
    @discardableResult
    func onSelect(_ value: ((SegmentedViewItem) -> Void)?) -> Self
    
}

public extension ISegmentedView {
    
    @inlinable
    @discardableResult
    func items(_ value: [SegmentedViewItem]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedItem(_ value: SegmentedViewItem?) -> Self {
        self.selectedItem = value
        return self
    }
    
}
