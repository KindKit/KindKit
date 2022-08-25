//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitObserver

public protocol IPageIndicatorView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var pageColor: Color { set get }
    
    var currentPageColor: Color { set get }
    
    var currentPage: Float { set get }
    
    var numberOfPages: UInt { set get }
    
    var pagingView: IPagingView? { set get }
    
}

public extension IPageIndicatorView {
    
    @inlinable
    @discardableResult
    func pageColor(_ value: Color) -> Self {
        self.pageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPageColor(_ value: Color) -> Self {
        self.currentPageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Float) -> Self {
        self.currentPage = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfPages(_ value: UInt) -> Self {
        self.numberOfPages = value
        return self
    }
    
    @inlinable
    @discardableResult
    func pagingView(_ value: IPagingView?) -> Self {
        self.pagingView = value
        return self
    }
    
}
