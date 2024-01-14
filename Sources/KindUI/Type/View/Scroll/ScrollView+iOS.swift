//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension ScrollView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ScrollView
        typealias Content = KKScrollView

        static var reuseIdentificator: String {
            return "ScrollView"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKScrollView : UIScrollView {
    
    weak var kkDelegate: KKScrollViewDelegate?
    var kkContentView: UIView!
    var kkRefreshView: UIRefreshControl!
    var kkLayoutManager: LayoutManager!
    var kkContentInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkContentInset != oldValue else { return }
            self.contentInset = self._contentInset()
        }
    }
    var kkContentSize: CGSize = .zero {
        didSet {
            guard self.kkContentSize != oldValue else { return }
            self.contentSize = .init(
                width: self.kkContentSize.width * self.zoomScale,
                height: self.kkContentSize.height * self.zoomScale
            )
            self.kkZoomingInset = self._zoomingInset()
            self.kkDelegate?.update(self, contentSize: .init(self.kkContentSize))
        }
    }
    var kkZoomingInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkZoomingInset != oldValue else { return }
            self.contentInset = self._contentInset()
        }
    }
    let kkVirtualKeyboard = VirtualKeyboard()
    
    override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            if self.frame.size != oldValue.size {
                if self.window != nil {
                    self.kkLayoutManager.invalidate()
                }
                self.setNeedsLayout()
            }
        }
    }
    override var contentSize: CGSize {
        set {
            guard super.contentSize != newValue else { return }
            self.kkContentView.frame = CGRect(origin: .zero, size: newValue)
            super.contentSize = newValue
            self.setNeedsLayout()
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
        
        self.kkLayoutManager = .init(
            delegate: self,
            view: self.kkContentView
        )
        
        self.kkVirtualKeyboard.add(observer: self, priority: .public)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.kkVirtualKeyboard.remove(observer: self)
    }
    
    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self.kkLayoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.kkLayoutManager.visibleFrame = .init(self.bounds)
        self.kkLayoutManager.updateIfNeeded()
        self.kkContentSize = self.kkLayoutManager.size.cgSize
    }
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        self.kkLayoutManager.contentInsets = .init(self.safeAreaInsets)
        self.scrollIndicatorInsets = self._scrollIndicatorInset()
    }
    
}

extension KKScrollView : IVirtualKeyboardObserver {

    func willShow(_ virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
    func didShow(_ virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
        guard let view = self.kk_firstResponder else {
            return
        }
        guard let contentOffset = self.contentOffset(with: view, horizontal: .center, vertical: .center) else {
            return
        }
        self.setContentOffset(contentOffset, animated: true)
    }

    func willHide(_ virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
    func didHide(_ virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }

}

extension KKScrollView {
    
    func contentOffset(
        with view: UIView,
        horizontal: ScrollView.ScrollAlignment,
        vertical: ScrollView.ScrollAlignment
    ) -> CGPoint? {
        let contentInset = self.contentInset
        let contentSize = self.contentSize
        let visibleSize = self.bounds.size
        let viewFrame = Rect(view.convert(view.bounds, to: self))
        let x: CGFloat
        if contentSize.width > visibleSize.width {
            switch horizontal {
            case .leading: x = -contentInset.left + viewFrame.x
            case .center: x = -contentInset.left + ((viewFrame.x + (viewFrame.width / 2)) - ((visibleSize.width - contentInset.right) / 2))
            case .trailing: x = ((viewFrame.x + viewFrame.width) - visibleSize.width) + contentInset.right
            }
        } else {
            x = -contentInset.left + viewFrame.x
        }
        let y: CGFloat
        if contentSize.height > visibleSize.height {
            switch vertical {
            case .leading: y = -contentInset.top + viewFrame.y
            case .center: y = -contentInset.top + ((viewFrame.y + (viewFrame.size.height / 2)) - ((visibleSize.height - contentInset.bottom) / 2))
            case .trailing: y = ((viewFrame.y + viewFrame.size.height) - visibleSize.height) + contentInset.bottom
            }
        } else {
            y = -contentInset.top + viewFrame.y
        }
        let lowerX = -contentInset.left
        let lowerY = -contentInset.top
        let upperX = (contentSize.width - visibleSize.width) + contentInset.right
        let upperY = (contentSize.height - visibleSize.height) + contentInset.bottom
        return CGPoint(
            x: max(lowerX, min(x, upperX)),
            y: max(lowerY, min(y, upperY))
        )
    }
    
}

extension KKScrollView {
    
    func update(view: ScrollView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(bounce: view.bounce)
        self.update(direction: view.direction)
        self.update(indicatorDirection: view.indicatorDirection)
        self.update(delaysContentTouches: view.delaysContentTouches)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(contentOffset: view.contentOffset)
        self.update(zoom: view.zoom, limit: view.zoomLimit)
        self.update(content: view.content)
        self.update(refreshColor: view.refreshColor)
        self.update(isRefreshing: view.isRefreshing)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(content: ILayout?) {
        self.kkLayoutManager.layout = content
        self.setNeedsLayout()
    }
    
    func update(bounce: ScrollView.Bounce) {
        self.alwaysBounceHorizontal = bounce.contains(.horizontal)
        self.alwaysBounceVertical = bounce.contains(.vertical)
        self.bouncesZoom = bounce.contains(.zoom)
    }
    
    func update(direction: ScrollView.Direction) {
    }
    
    func update(indicatorDirection: ScrollView.Direction) {
        self.showsHorizontalScrollIndicator = indicatorDirection.contains(.horizontal)
        self.showsVerticalScrollIndicator = indicatorDirection.contains(.vertical)
    }
    
    func update(delaysContentTouches: Bool) {
        self.delaysContentTouches = delaysContentTouches
    }
    
    func update(visibleInset: Inset) {
        self.kkLayoutManager.preloadInsets = visibleInset
    }
    
    func update(contentInset: Inset) {
        self.kkContentInset = contentInset.uiEdgeInsets
        self.scrollIndicatorInsets = self._scrollIndicatorInset()
        if self.superview != nil {
            self.kkLayoutManager.invalidate()
        }
    }
    
    func update(contentSize: Size) {
        self.kkContentSize = contentSize.cgSize
    }
    
    func update(contentOffset: Point) {
        self.setContentOffset(contentOffset.cgPoint, animated: false)
    }
    
    func update(zoom: Double, limit: Range< Double >) {
        self.zoomScale = zoom
        self.minimumZoomScale = limit.lowerBound
        self.maximumZoomScale = limit.upperBound
    }
    
    func update(refreshColor: Color?) {
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
    
    func update(isRefreshing: Bool) {
        if isRefreshing == true {
            self.kkRefreshView.beginRefreshing()
        } else {
            self.kkRefreshView.endRefreshing()
        }
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.isScrollEnabled = locked == false
    }
    
    func cleanup() {
        self.kkContentView.transform = .identity
        self.kkLayoutManager.layout = nil
        self.kkDelegate = nil
        self.kkZoomingInset = .zero
        self.kkContentInset = .zero
        self.scrollIndicatorInsets = .zero
        self.contentOffset = .zero
        self.kkContentSize = .zero
        self.zoomScale = 1
    }
    
}

private extension KKScrollView {
    
    @objc
    func _triggeredRefresh(_ sender: Any) {
        self.kkDelegate?.triggeredRefresh(self)
    }
    
    func _zoomingInset() -> UIEdgeInsets {
        guard self.minimumZoomScale != self.maximumZoomScale else {
            return .zero
        }
        let contentSize = self.contentSize
        let contentWidth = contentSize.width
        let contentHeight = contentSize.height
        let viewSize = self.bounds.size
        let viewWidth = viewSize.width
        let viewHeight = viewSize.height
        let hp = (viewWidth > contentWidth) ? (viewWidth - contentWidth) / 2 : 0
        let vp = (viewHeight > contentHeight) ? (viewHeight - contentHeight) / 2 : 0
        return .init(
            top: vp,
            left: hp,
            bottom: vp,
            right: hp
        )
    }
    
    func _contentInset() -> UIEdgeInsets {
        let contentInset = self.kkContentInset
        let zoomingInset = self.kkZoomingInset
        return .init(
            top: max(zoomingInset.top, contentInset.top),
            left: max(zoomingInset.left, contentInset.left),
            bottom: max(zoomingInset.bottom, contentInset.bottom),
            right: max(zoomingInset.right, contentInset.right)
        )
    }
    
    func _scrollIndicatorInset() -> UIEdgeInsets {
        let contentInset = self.kkContentInset
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        guard self.window != nil else { return nil }
        return self.kkContentView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.kkDelegate?.beginZooming(self)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard self.window != nil else { return }
        self.kkZoomingInset = self._zoomingInset()
        self.kkDelegate?.zooming(self, zoom: scrollView.zoomScale)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.kkDelegate?.endZooming(self)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.kkDelegate?.beginDragging(self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.window != nil else { return }
        self.kkDelegate?.dragging(self, contentOffset: Point(scrollView.contentOffset))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.kkDelegate?.endDragging(self, decelerate: decelerate)
        if decelerate == false {
            self.setNeedsLayout()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.kkDelegate?.beginDecelerating(self)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.kkDelegate?.endDecelerating(self)
        self.setNeedsLayout()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard self.window != nil else { return }
        self.kkDelegate?.scrollToTop(self)
    }
    
}

extension KKScrollView : ILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: ILayout) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        defer {
            self.setNeedsLayout()
        }
        guard delegate.isDynamic(self) == true else {
            self.kkLayoutManager.setNeed(layout: true)
            return false
        }
        self.kkLayoutManager.setNeed(layout: true)
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: ILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
