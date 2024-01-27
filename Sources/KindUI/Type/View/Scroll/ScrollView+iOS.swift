//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindLayout

extension ScrollView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ScrollView
        typealias Content = KKScrollView
        
        static func name(owner: Owner) -> String {
            return "ScrollView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKScrollView : UIScrollView {
    
    weak var kkDelegate: KKScrollViewDelegate?
    var kkContentView: UIView!
    var kkRefreshView: UIRefreshControl!
    
    override var contentSize: CGSize {
        set {
            guard super.contentSize != newValue else { return }
            self.kkContentView.frame = CGRect(origin: .zero, size: newValue)
            super.contentSize = newValue
        }
        get { super.contentSize }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.delegate = self
        self.contentInsetAdjustmentBehavior = .never

        self.kkContentView = UIView(frame: .init(
            origin: .zero,
            size: frame.size
        ))
        self.addSubview(self.kkContentView)
        
        self.kkRefreshView = UIRefreshControl()
        self.kkRefreshView.addTarget(self, action: #selector(self._triggeredRefresh(_:)), for: .valueChanged)
        self.refreshControl = self.kkRefreshView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        self.scrollIndicatorInsets = self._scrollIndicatorInset()
    }
    
}

extension KKScrollView {
    
    final func kk_update< LayoutType : ILayout >(view: ScrollView< LayoutType >) {
        self.kk_update(frame: view.frame)
        self.kk_update(bounce: view.bounce)
        self.kk_update(indicatorDirection: view.indicatorDirection)
        self.kk_update(delaysContentTouches: view.delaysContentTouches)
        self.kk_update(adjustmentInset: view.adjustmentInset)
        self.kk_update(contentSize: view.contentSize)
        self.kk_update(contentOffset: view.contentOffset)
        self.kk_update(zoom: view.zoom, limit: view.zoomLimit)
        self.kk_update(refreshColor: view.refreshColor)
        self.kk_update(isRefreshing: view.isRefreshing)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kk_update(enabled: view.isEnabled)
        view.holder = LayoutHolder(self.kkContentView)
        self.kkDelegate = view
    }
    
    final func kk_cleanup< LayoutType : ILayout >(view: ScrollView< LayoutType >) {
        self.kkContentView.transform = .identity
        self.contentInset = .zero
        self.scrollIndicatorInsets = .zero
        self.contentSize = .zero
        self.contentOffset = .zero
        self.zoomScale = 1
        view.holder = nil
        self.kkDelegate = nil
    }
    
}

extension KKScrollView {
    
    final func kk_update(bounce: ScrollBounce) {
        self.alwaysBounceHorizontal = bounce.contains(.horizontal)
        self.alwaysBounceVertical = bounce.contains(.vertical)
        self.bouncesZoom = bounce.contains(.zoom)
    }
    
    final func kk_update(indicatorDirection: ScrollDirection) {
        self.showsHorizontalScrollIndicator = indicatorDirection.contains(.horizontal)
        self.showsVerticalScrollIndicator = indicatorDirection.contains(.vertical)
    }
    
    final func kk_update(delaysContentTouches: Bool) {
        self.delaysContentTouches = delaysContentTouches
    }
    
    final func kk_update(adjustmentInset: Inset) {
        self.contentInset = adjustmentInset.uiEdgeInsets
        self.scrollIndicatorInsets = self._scrollIndicatorInset()
    }
    
    final func kk_update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    final func kk_update(contentOffset: Point) {
        self.setContentOffset(contentOffset.cgPoint, animated: false)
    }
    
    final func kk_update(zoom: Double, limit: Range< Double >) {
        self.zoomScale = zoom
        self.minimumZoomScale = limit.lowerBound
        self.maximumZoomScale = limit.upperBound
    }
    
    final func kk_update(refreshColor: Color?) {
        if let refreshColor = refreshColor {
            self.kkRefreshView.tintColor = refreshColor.native
            if self.refreshControl != self.kkRefreshView {
                self.refreshControl = self.kkRefreshView
            }
        } else {
            if self.refreshControl == self.kkRefreshView {
                self.refreshControl = nil
            }
        }
    }
    
    final func kk_update(isRefreshing: Bool) {
        if isRefreshing == true {
            self.kkRefreshView.beginRefreshing()
        } else {
            self.kkRefreshView.endRefreshing()
        }
    }
    
    final func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    final func kk_update(enabled: Bool) {
        self.isScrollEnabled = enabled
    }
    
}

private extension KKScrollView {
    
    @objc
    func _triggeredRefresh(_ sender: Any) {
        self.kkDelegate?.kk_triggeredRefresh(self)
    }
    
    func _scrollIndicatorInset() -> UIEdgeInsets {
        let contentInset = self.contentInset
        let safeArea = self.safeAreaInsets
        return .init(
            top: contentInset.top - safeArea.top,
            left: contentInset.left - safeArea.left,
            bottom: contentInset.bottom - safeArea.bottom,
            right: contentInset.right - safeArea.right
        )
    }
    
}

extension KKScrollView : UIScrollViewDelegate {
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard self.window != nil else { return }
        self.kkDelegate?.kk_scrollToTop(self)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.kkDelegate?.kk_beginDragging(self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.window != nil else { return }
        self.kkDelegate?.kk_update(self, contentOffset: Point(scrollView.contentOffset))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.kkDelegate?.kk_endDragging(self, decelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.kkDelegate?.kk_beginDecelerating(self)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.kkDelegate?.kk_endDecelerating(self)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        guard self.window != nil else { return nil }
        return self.kkContentView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.kkDelegate?.kk_beginZooming(self)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard self.window != nil else { return }
        self.kkDelegate?.kk_update(self, zoom: scrollView.zoomScale)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.kkDelegate?.kk_endZooming(self)
    }
    
}

#endif
