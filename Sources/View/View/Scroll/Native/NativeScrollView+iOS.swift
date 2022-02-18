//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension ScrollView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ScrollView
        typealias Content = NativeScrollView

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

final class NativeScrollView : UIScrollView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: ScrollViewDelegate?
    var needLayoutContent: Bool {
        didSet(oldValue) {
            if self.needLayoutContent == true {
                self.setNeedsLayout()
            }
        }
    }
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                let oldValue = value
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
                if oldValue.size != value.size {
                    self.needLayoutContent = true
                    self.setNeedsLayout()
                }
            }
        }
        get { return super.frame }
    }
    override var contentSize: CGSize {
        set(value) {
            if super.contentSize != value {
                self._contentView.frame = CGRect(origin: CGPoint.zero, size: value)
                super.contentSize = value
                self.setNeedsLayout()
            }
        }
        get { return super.contentSize }
    }
    
    private unowned var _view: View?
    private var _contentView: UIView!
    private var _refreshView: UIRefreshControl!
    private var _layoutManager: LayoutManager!
    private var _visibleInset: InsetFloat {
        didSet(oldValue) {
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
        if #available(iOS 10.0, *) {
            self.refreshControl = self._refreshView
        }
        
        self._layoutManager = LayoutManager(contentView: self._contentView, delegate: self)
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
                self.customDelegate?._update(contentSize: size)
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

extension NativeScrollView {
    
    func update< Layout : ILayout >(view: ScrollView< Layout >) {
        self._view = view
        self.update(direction: view.direction)
        self.update(indicatorDirection: view.indicatorDirection)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(contentOffset: view.contentOffset, normalized: true)
        self.update(contentLayout: view.contentLayout)
        if #available(iOS 10.0, *) {
            self.update(refreshColor: view.refreshColor)
            self.update(isRefreshing: view.isRefreshing)
        }
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(contentLayout: ILayout) {
        self._layoutManager.layout = contentLayout
        self.needLayoutContent = true
    }
    
    func update(direction: ScrollViewDirection) {
        self.alwaysBounceHorizontal = direction.contains(.horizontal) && direction.contains(.bounds)
        self.alwaysBounceVertical = direction.contains(.vertical) && direction.contains(.bounds)
        self.needLayoutContent = true
    }
    
    func update(indicatorDirection: ScrollViewDirection) {
        self.showsHorizontalScrollIndicator = indicatorDirection.contains(.horizontal)
        self.showsVerticalScrollIndicator = indicatorDirection.contains(.vertical)
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
    
    @available(iOS 10.0, *)
    func update(refreshColor: Color?) {
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
    
    @available(iOS 10.0, *)
    func update(isRefreshing: Bool) {
        if isRefreshing == true {
            self._refreshView.beginRefreshing()
        } else {
            self._refreshView.endRefreshing()
        }
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.customDelegate = nil
        self._view = nil
    }
    
    func contentOffset(with view: IView, horizontal: ScrollViewScrollAlignment, vertical: ScrollViewScrollAlignment) -> PointFloat? {
        guard let item = view.item else { return nil }
        let contentInset = InsetFloat(self.contentInset)
        let contentSize = SizeFloat(self.contentSize)
        let visibleSize = SizeFloat(self.bounds.size)
        let itemFrame = item.frame
        let x: Float
        switch horizontal {
        case .leading: x = -contentInset.left + itemFrame.x
        case .center: x = -contentInset.left + ((itemFrame.x + (itemFrame.width / 2)) - ((visibleSize.width - contentInset.right) / 2))
        case .trailing: x = ((itemFrame.x + itemFrame.width) - visibleSize.width) + contentInset.right
        }
        let y: Float
        switch vertical {
        case .leading: y = -contentInset.top + itemFrame.y
        case .center: y = -contentInset.top + ((itemFrame.y + (itemFrame.size.height / 2)) - ((visibleSize.height - contentInset.bottom) / 2))
        case .trailing: y = ((itemFrame.y + itemFrame.size.height) - visibleSize.height) + contentInset.bottom
        }
        let lowerX = -contentInset.left
        let lowerY = -contentInset.top
        let upperX = (contentSize.width - visibleSize.width) + contentInset.right
        let upperY = (contentSize.height - visibleSize.height) + contentInset.bottom
        return PointFloat(
            x: max(lowerX, min(x, upperX)),
            y: max(lowerY, min(y, upperY))
        )
    }
    
}

private extension NativeScrollView {
    
    @objc
    func _triggeredRefresh(_ sender: Any) {
        self.customDelegate?._triggeredRefresh()
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

extension NativeScrollView : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.customDelegate?._beginScrolling()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.customDelegate?._scrolling(contentOffset: PointFloat(scrollView.contentOffset))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.customDelegate?._endScrolling(decelerate: decelerate)
        if decelerate == false {
            self.setNeedsLayout()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.customDelegate?._beginDecelerating()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.customDelegate?._endDecelerating()
        self.setNeedsLayout()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.customDelegate?._scrollToTop()
    }
    
}

extension NativeScrollView : ILayoutDelegate {
    
    func setNeedUpdate(_ layout: ILayout) -> Bool {
        self.needLayoutContent = true
        self.setNeedsLayout()
        if let customDelegate = self.customDelegate {
            return customDelegate._isDynamicSize()
        }
        return false
    }
    
    func updateIfNeeded(_ layout: ILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
