//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Scroll {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Scroll
        typealias Content = KKScrollView

        static var reuseIdentificator: String {
            return "UI.View.Scroll"
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
    var kkLayoutManager: UI.Layout.Manager!
    var kkVisibleInset: Inset = .zero {
        didSet {
            guard self.kkVisibleInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkNeedLayoutContent: Bool = true {
        didSet {
            if self.kkNeedLayoutContent == true {
                self.setNeedsLayout()
            }
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
                self.kkNeedLayoutContent = true
            }
        }
    }
    override var contentSize: CGSize {
        set {
            guard super.contentSize != newValue else { return }
            self.kkContentView.frame = CGRect(origin: CGPoint.zero, size: newValue)
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
        
        self.kkLayoutManager = UI.Layout.Manager(contentView: self.kkContentView, delegate: self)
        
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
            self.kkNeedLayoutContent = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        do {
            if self.kkNeedLayoutContent == true {
                let bounds = Rect(self.bounds)
                let layoutBounds: Rect
                if #available(iOS 11.0, *) {
                    layoutBounds = .init(
                    	origin: .zero,
                    	size: bounds.size.inset(self.adjustedContentInset)
                	)
                } else {
                    layoutBounds = .init(
                    	origin: .zero,
                    	size: bounds.size
                	)
                }
                self.kkLayoutManager.layout(bounds: layoutBounds)
                let size = self.kkLayoutManager.size
                self.contentSize = size.cgSize
                self.kkDelegate?.update(self, contentSize: size)
                self.kkNeedLayoutContent = false
            }
            self.kkLayoutManager.visible(
                bounds: Rect(self.bounds),
                inset: self.kkVisibleInset
            )
        }
    }
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        self.scrollIndicatorInsets = self._scrollIndicatorInset()
    }
    
}

extension KKScrollView : IVirtualKeyboardObserver {

    func willShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
    func didShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
        guard let view = self.kk_firstResponder else {
            return
        }
        guard let contentOffset = self.contentOffset(with: view, horizontal: .center, vertical: .center) else {
            return
        }
        self.setContentOffset(contentOffset, animated: true)
    }

    func willHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
    func didHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }

}

extension KKScrollView {
    
    func contentOffset(
        with view: UIView,
        horizontal: UI.View.Scroll.ScrollAlignment,
        vertical: UI.View.Scroll.ScrollAlignment
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
    
    func update(view: UI.View.Scroll) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(direction: view.direction)
        self.update(indicatorDirection: view.indicatorDirection)
        self.update(delaysContentTouches: view.delaysContentTouches)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(contentOffset: view.contentOffset)
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
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(content: IUILayout?) {
        self.kkLayoutManager.layout = content
        self.kkNeedLayoutContent = true
    }
    
    func update(direction: UI.View.Scroll.Direction) {
        self.alwaysBounceHorizontal = direction.contains(.horizontal) && direction.contains(.bounds)
        self.alwaysBounceVertical = direction.contains(.vertical) && direction.contains(.bounds)
        self.kkNeedLayoutContent = true
    }
    
    func update(indicatorDirection: UI.View.Scroll.Direction) {
        self.showsHorizontalScrollIndicator = indicatorDirection.contains(.horizontal)
        self.showsVerticalScrollIndicator = indicatorDirection.contains(.vertical)
    }
    
    func update(delaysContentTouches: Bool) {
        self.delaysContentTouches = delaysContentTouches
    }
    
    func update(visibleInset: Inset) {
        self.kkVisibleInset = visibleInset
    }
    
    func update(contentInset: Inset) {
        self.contentInset = contentInset.uiEdgeInsets
        self.scrollIndicatorInsets = self._scrollIndicatorInset()
        if self.superview != nil {
            self.kkLayoutManager.invalidate()
        }
        self.kkNeedLayoutContent = true
    }
    
    func update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentOffset: Point) {
        self.setContentOffset(contentOffset.cgPoint, animated: false)
    }
    
    func update(refreshColor: UI.Color?) {
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
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.isScrollEnabled = locked == false
    }
    
    func cleanup() {
        self.kkLayoutManager.layout = nil
        self.kkDelegate = nil
        self.scrollIndicatorInsets = .zero
        self.contentInset = .zero
        self.contentOffset = .zero
        self.contentSize = .zero
    }
    
}

private extension KKScrollView {
    
    @objc
    func _triggeredRefresh(_ sender: Any) {
        self.kkDelegate?.triggeredRefresh(self)
    }
    
    func _scrollIndicatorInset() -> UIEdgeInsets {
        let contentInset = self.contentInset
        let safeArea = self.safeAreaInsets
        return UIEdgeInsets(
            top: contentInset.top - safeArea.top,
            left: contentInset.left - safeArea.left,
            bottom: contentInset.bottom - safeArea.bottom,
            right: contentInset.right - safeArea.right
        )
    }
    
}

extension KKScrollView : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.kkDelegate?.beginDragging(self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        self.kkDelegate?.scrollToTop(self)
    }
    
}

extension KKScrollView : IUILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: IUILayout) -> Bool {
        self.kkNeedLayoutContent = true
        if let kkDelegate = self.kkDelegate {
            return kkDelegate.isDynamicSize(self)
        }
        return false
    }
    
    func updateIfNeeded(_ appearedLayout: IUILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
