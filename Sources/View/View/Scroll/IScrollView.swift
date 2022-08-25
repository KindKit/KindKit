//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitObserver

public struct ScrollViewDirection : OptionSet {
    
    public typealias RawValue = UInt
    
    public var rawValue: UInt
    
    @inlinable
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static var horizontal = ScrollViewDirection(rawValue: 1 << 0)
    public static var vertical = ScrollViewDirection(rawValue: 1 << 1)
    public static var bounds = ScrollViewDirection(rawValue: 1 << 2)
    
}

public enum ScrollViewScrollAlignment {
    
    case leading
    case center
    case trailing
    
}

public protocol IScrollViewObserver : AnyObject {
    
    func beginScrolling(scrollView: IScrollView)
    func scrolling(scrollView: IScrollView)
    func endScrolling(scrollView: IScrollView, decelerate: Bool)
    func beginDecelerating(scrollView: IScrollView)
    func endDecelerating(scrollView: IScrollView)
    
    func scrollToTop(scrollView: IScrollView)
    
}

public protocol IScrollView : IView, IViewDynamicSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var direction: ScrollViewDirection { set get }
    
    var indicatorDirection: ScrollViewDirection { set get }
    
    var visibleInset: InsetFloat { set get }
    
    var contentInset: InsetFloat { set get }
    
    var contentOffset: PointFloat { set get }
    
    var contentSize: SizeFloat { get }
    
    var isScrolling: Bool { get }
    
    var isDecelerating: Bool { get }
    
    #if os(iOS)
    
    var refreshColor: Color? { set get }
    
    var isRefreshing: Bool { get }
    
    #endif
    
    func add(observer: IScrollViewObserver)
    
    func remove(observer: IScrollViewObserver)
    
    func scrollToTop(animated: Bool, completion: (() -> Void)?)

    func contentOffset(
        with view: IView,
        horizontal: ScrollViewScrollAlignment,
        vertical: ScrollViewScrollAlignment
    ) -> PointFloat?
    
    func contentOffset(_ value: PointFloat, normalized: Bool) -> Self
    
    #if os(iOS)
    
    @discardableResult
    func beginRefresh() -> Self
    
    @discardableResult
    func endRefresh() -> Self
    
    @discardableResult
    func onTriggeredRefresh(_ value: (() -> Void)?) -> Self
    
    #endif
    
    @discardableResult
    func onBeginScrolling(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onScrolling(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndScrolling(_ value: ((_ decelerate: Bool) -> Void)?) -> Self
    
    @discardableResult
    func onBeginDecelerating(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndDecelerating(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onScrollToTop(_ value: (() -> Void)?) -> Self
    
}

public extension IScrollView {
    
    var estimatedContentOffset: PointFloat {
        let size = self.bounds.size
        let contentOffset = self.contentOffset
        let contentSize = self.contentSize
        let contentInset = self.contentInset
        return PointFloat(
            x: (contentInset.left + contentSize.width + contentInset.right) - (contentOffset.x + size.width),
            y: (contentInset.top + contentSize.height + contentInset.bottom) - (contentOffset.y + size.height)
        )
    }
    
    @inlinable
    @discardableResult
    func contentOffset(_ value: PointFloat, normalized: Bool = false) -> Self {
        return self.contentOffset(value, normalized: normalized)
    }
    
    @inlinable
    @discardableResult
    func direction(_ value: ScrollViewDirection) -> Self {
        self.direction = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicatorDirection(_ value: ScrollViewDirection) -> Self {
        self.indicatorDirection = value
        return self
    }
    
    @inlinable
    @discardableResult
    func visibleInset(_ value: InsetFloat) -> Self {
        self.visibleInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: InsetFloat) -> Self {
        self.contentInset = value
        return self
    }
    
    #if os(iOS)
    
    @available(iOS 10.0, *)
    @inlinable
    @discardableResult
    func refreshColor(_ value: Color?) -> Self {
        self.refreshColor = value
        return self
    }
    
    #endif
    
    @inlinable
    func scrollToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.scrollToTop(animated: animated, completion: completion)
    }
    
}
