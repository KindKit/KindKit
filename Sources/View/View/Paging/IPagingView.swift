//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitObserver

public enum PagingViewDirection : Equatable {
    
    case horizontal(bounds: Bool)
    case vertical(bounds: Bool)
    
}

public protocol IPagingViewObserver : AnyObject {
    
    func beginPaginging(pagingView: IPagingView)
    func paginging(pagingView: IPagingView)
    func endPaginging(pagingView: IPagingView, decelerate: Bool)
    func beginDecelerating(pagingView: IPagingView)
    func endDecelerating(pagingView: IPagingView)
    
}

public protocol IPagingView : IView, IViewDynamicSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var direction: PagingViewDirection { set get }
    
    var visibleInset: InsetFloat { set get }
    
    var contentInset: InsetFloat { set get }
    
    var currentPage: Float { set get }
    
    var numberOfPages: UInt { get }
    
    var contentSize: SizeFloat { get }
    
    var isPaging: Bool { get }
    
    var isDecelerating: Bool { get }
    
    func add(observer: IPagingViewObserver)
    
    func remove(observer: IPagingViewObserver)
    
    func add(pageIndicator: IPageIndicatorView)
    
    func remove(pageIndicator: IPageIndicatorView)
    
    @discardableResult
    func onBeginPaginging(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onPaginging(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndPaginging(_ value: ((_ decelerate: Bool) -> Void)?) -> Self
    
    @discardableResult
    func onBeginDecelerating(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndDecelerating(_ value: (() -> Void)?) -> Self
    
}

public extension IPagingView {

    @inlinable
    var isFirstPage: Bool {
        guard self.numberOfPages > 0 else { return false }
        return UInt(self.currentPage.roundNearest) == 0
    }
    
    @inlinable
    var isLastPage: Bool {
        guard self.numberOfPages > 0 else { return false }
        return UInt(self.currentPage.roundNearest) == self.numberOfPages - 1
    }

    @inlinable
    @discardableResult
    func direction(_ value: PagingViewDirection) -> Self {
        self.direction = value
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
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Float) -> Self {
        self.currentPage = value
        return self
    }
    
    func scrollTo(
        page: UInt,
        duration: TimeInterval? = 0.2,
        completion: (() -> Void)? = nil
    ) {
        let newPage = Float(page)
        let oldPage = self.currentPage
        if newPage != oldPage {
            if let duration = duration {
                Animation.default.run(
                    duration: duration,
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [weak self] progress in
                        self?.currentPage = oldPage.lerp(newPage, progress: progress)
                    },
                    completion: { completion?() }
                )
            } else {
                self.currentPage = newPage
                completion?()
            }
        } else {
            completion?()
        }
    }
    
}
