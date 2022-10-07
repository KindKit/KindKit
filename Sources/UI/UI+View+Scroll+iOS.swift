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
    
    unowned var kkDelegate: KKScrollViewDelegate?
    var needLayoutContent: Bool {
        didSet {
            if self.needLayoutContent == true {
                self.setNeedsLayout()
            }
        }
    }
    override var frame: CGRect {
        set {
            let oldValue = super.frame
            if oldValue != newValue {
                super.frame = newValue
                if let view = self._view {
                    self.kk_update(cornerRadius: view.cornerRadius)
                    self.kk_updateShadowPath()
                }
                if oldValue.size != newValue.size {
                    self.needLayoutContent = true
                }
            }
        }
        get { super.frame }
    }
    override var contentSize: CGSize {
        set {
            guard super.contentSize != newValue else { return }
            self._contentView.frame = CGRect(origin: CGPoint.zero, size: newValue)
            super.contentSize = newValue
            self.setNeedsLayout()
        }
        get { super.contentSize }
    }
    
    private unowned var _view: UI.View.Scroll?
    private var _contentView: UIView!
    private var _refreshView: UIRefreshControl!
    private var _layoutManager: UI.Layout.Manager!
    private var _visibleInset: InsetFloat {
        didSet {
            guard self._visibleInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    private var _isLayout: Bool
    
    override init(frame: CGRect) {
        self.needLayoutContent = true
        self._visibleInset = .zero
        self._isLayout = false
        
        super.init(frame: frame)

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.clipsToBounds = true
        self.delegate = self
        
        self._contentView = UIView(frame: .zero)
        self.addSubview(self._contentView)
        
        self._refreshView = UIRefreshControl()
        self._refreshView.addTarget(self, action: #selector(self._triggeredRefresh(_:)), for: .valueChanged)
        self.refreshControl = self._refreshView
        
        self._layoutManager = UI.Layout.Manager(contentView: self._contentView, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self._safeLayout({
            let bounds = self.bounds
            if self.needLayoutContent == true {
                self.needLayoutContent = false
                
                let layoutBounds: RectFloat
                if #available(iOS 11.0, *) {
                    let inset = self.adjustedContentInset
                    layoutBounds = RectFloat(
                        x: 0,
                        y: 0,
                        width: Float(bounds.size.width - (inset.left + inset.right)),
                        height: Float(bounds.size.height - (inset.top + inset.bottom))
                    )
                } else {
                    layoutBounds = RectFloat(
                        x: 0,
                        y: 0,
                        width: Float(bounds.size.width),
                        height: Float(bounds.size.height)
                    )
                }
                self._layoutManager.layout(bounds: layoutBounds)
                let size = self._layoutManager.size
                self.contentSize = size.cgSize
                self.kkDelegate?.update(self, contentSize: size)
            }
            self._layoutManager.visible(
                bounds: RectFloat(bounds),
                inset: self._visibleInset
            )
        })
    }
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        self.scrollIndicatorInsets = self._scrollIndicatorInsets()
    }
    
}

extension KKScrollView {
    
    func update(view: UI.View.Scroll) {
        self._view = view
        self.update(direction: view.direction)
        self.update(indicatorDirection: view.indicatorDirection)
        self.update(delaysContentTouches: view.delaysContentTouches)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(contentOffset: view.contentOffset, normalized: true)
        self.update(content: view.content)
        self.update(refreshColor: view.refreshColor)
        self.update(isRefreshing: view.isRefreshing)
        self.update(locked: view.isLocked)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(locked: Bool) {
        self.isScrollEnabled = locked == false
    }
    
    func update(content: IUILayout) {
        self._layoutManager.layout = content
        self.needLayoutContent = true
    }
    
    func update(direction: UI.View.Scroll.Direction) {
        self.alwaysBounceHorizontal = direction.contains(.horizontal) && direction.contains(.bounds)
        self.alwaysBounceVertical = direction.contains(.vertical) && direction.contains(.bounds)
        self.needLayoutContent = true
    }
    
    func update(indicatorDirection: UI.View.Scroll.Direction) {
        self.showsHorizontalScrollIndicator = indicatorDirection.contains(.horizontal)
        self.showsVerticalScrollIndicator = indicatorDirection.contains(.vertical)
    }
    
    func update(delaysContentTouches: Bool) {
        self.delaysContentTouches = delaysContentTouches
    }
    
    func update(visibleInset: InsetFloat) {
        self._visibleInset = visibleInset
    }
    
    func update(contentInset: InsetFloat) {
        self.contentInset = contentInset.uiEdgeInsets
        self.scrollIndicatorInsets = self._scrollIndicatorInsets()
    }
    
    func update(contentSize: SizeFloat) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentOffset: PointFloat, normalized: Bool) {
        let validContentOffset: CGPoint
        if normalized == true {
            let contentInset = self.contentInset
            let contentSize = self.contentSize
            let visibleSize = self.bounds.size
            validContentOffset = CGPoint(
                x: max(-contentInset.left, min(-contentInset.left + CGFloat(contentOffset.x), contentSize.width - visibleSize.width + contentInset.right)),
                y: max(-contentInset.top, min(-contentInset.top + CGFloat(contentOffset.y), contentSize.height - visibleSize.height + contentInset.bottom))
            )
        } else {
            validContentOffset = contentOffset.cgPoint
        }
        self.setContentOffset(validContentOffset, animated: false)
    }
    
    func update(refreshColor: UI.Color?) {
        if let refreshColor = refreshColor {
            self._refreshView.tintColor = refreshColor.native
            if self.refreshControl != self._refreshView {
                self.refreshControl = self._refreshView
            }
        } else {
            if self.refreshControl == self._refreshView {
                self.refreshControl = nil
            }
        }
    }
    
    func update(isRefreshing: Bool) {
        if isRefreshing == true {
            self._refreshView.beginRefreshing()
        } else {
            self._refreshView.endRefreshing()
        }
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKScrollView {
    
    @objc
    func _triggeredRefresh(_ sender: Any) {
        self.kkDelegate?.triggeredRefresh(self)
    }
    
    func _scrollIndicatorInsets() -> UIEdgeInsets {
        let contentInset = self.contentInset
        let safeArea: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeArea = self.safeAreaInsets
        } else {
            safeArea = .zero
        }
        return UIEdgeInsets(
            top: contentInset.top - safeArea.top,
            left: contentInset.left - safeArea.left,
            bottom: contentInset.bottom - safeArea.bottom,
            right: contentInset.right - safeArea.right
        )
    }
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
    }
    
}

extension KKScrollView : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.kkDelegate?.beginDragging(self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.kkDelegate?.dragging(self, contentOffset: PointFloat(scrollView.contentOffset))
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
        self.needLayoutContent = true
        self.setNeedsLayout()
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
