//
//  KindKitView
//

#if os(macOS)

import AppKit
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

final class NativeScrollView : NSScrollView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: ScrollViewDelegate?
    var needLayoutContent: Bool {
        didSet(oldValue) {
            if self.needLayoutContent == true {
                self.documentView?.needsLayout = true
                self.contentView.needsLayout = true
            }
        }
    }
    override var contentSize: CGSize {
        set(value) {
            self.documentView?.frame = NSRect(origin: self.frame.origin, size: value)
        }
        get { return super.contentSize }
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
                }
            }
        }
        get { return super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private unowned var _view: View?
    private var _layoutManager: LayoutManager!
    private var _visibleInset: InsetFloat {
        didSet(oldValue) {
            guard self._visibleInset != oldValue else { return }
            self.needLayoutContent = true
        }
    }
    private var _isLayout: Bool
    
    override init(frame: CGRect) {
        self.needLayoutContent = true
        self._visibleInset = .zero
        self._isLayout = false
        
        super.init(frame: frame)
        
        self.autohidesScrollers = true
        self.contentView = NativeScrollContentView(owner: self)
        self.documentView = NativeScrollDocumentView(owner: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self._startScrolling(_:)), name: Self.willStartLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._scrolling(_:)), name: Self.didLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._endScrolling(_:)), name: Self.didEndLiveScrollNotification, object: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.documentView = nil
    }

    override func viewWillMove(toSuperview superview: NSView?) {
        super.viewWillMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    func layoutContent() {
        self._safeLayout({
            let bounds = self.bounds
            if self.needLayoutContent == true {
                self.needLayoutContent = false
                
                let layoutBounds = RectFloat(
                    x: 0,
                    y: 0,
                    width: Float(bounds.size.width),
                    height: Float(bounds.size.height)
                )
                self._layoutManager.layout(bounds: layoutBounds)
                self.contentSize = self._layoutManager.size.cgSize
                self.customDelegate?._update(contentSize: self._layoutManager.size)
            }
            self._layoutManager.visible(
                bounds: RectFloat(self.contentView.documentVisibleRect),
                inset: self._visibleInset
            )
        })
    }
    
}
    
final class NativeScrollContentView : NSClipView {
    
    unowned var _owner: NativeScrollView
    override var isFlipped: Bool {
        return true
    }

    init(owner: NativeScrollView) {
        self._owner = owner
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        self._owner.layoutContent()
    }
    
    override func scroll(to newOrigin: NSPoint) {
        super.scroll(to: newOrigin)
        
        self._owner.layoutContent()
    }
    
}

final class NativeScrollDocumentView : NSView {
    
    unowned var _owner: NativeScrollView
    override var isFlipped: Bool {
        return true
    }

    init(owner: NativeScrollView) {
        self._owner = owner
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        self._owner.layoutContent()
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
        self.horizontalScrollElasticity = direction.contains(.horizontal) && direction.contains(.bounds) ? .allowed : .none
        self.verticalScrollElasticity = direction.contains(.vertical) && direction.contains(.bounds) ? .allowed : .none
        self.needLayoutContent = true
    }
    
    func update(indicatorDirection: ScrollViewDirection) {
        self.hasHorizontalScroller = indicatorDirection.contains(.horizontal)
        self.hasVerticalScroller = indicatorDirection.contains(.vertical)
    }
    
    func update(visibleInset: InsetFloat) {
        self._visibleInset = visibleInset
    }
    
    func update(contentInset: InsetFloat) {
        self.contentInsets = contentInset.nsEdgeInsets
    }
    
    func update(contentSize: SizeFloat) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentOffset: PointFloat, normalized: Bool) {
        let validContentOffset: CGPoint
        if normalized == true {
            let contentInset = self.contentInsets
            let contentSize = self.contentSize
            let visibleSize = self.bounds.size
            validContentOffset = CGPoint(
                x: max(-contentInset.left, min(-contentInset.left + CGFloat(contentOffset.x), contentSize.width - visibleSize.width + contentInset.right)),
                y: max(-contentInset.top, min(-contentInset.top + CGFloat(contentOffset.y), contentSize.height - visibleSize.height + contentInset.bottom))
            )
        } else {
            validContentOffset = contentOffset.cgPoint
        }
        self.scroll(validContentOffset)
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativeScrollView {
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
    }
    
    @objc
    func _startScrolling(_ sender: Any) {
        self.customDelegate?._beginScrolling()
    }
    
    @objc
    func _scrolling(_ sender: Any) {
        self.customDelegate?._scrolling(contentOffset: Point(self.contentView.documentRect.origin))
    }
    
    @objc
    func _endScrolling(_ sender: Any) {
        self.customDelegate?._endScrolling(decelerate: false)
    }
    
}

extension NativeScrollView : ILayoutDelegate {
    
    func setNeedUpdate(_ layout: ILayout) -> Bool {
        self.needLayoutContent = true
        if let customDelegate = self.customDelegate {
            return customDelegate._isDynamicSize()
        }
        return false
    }
    
    func updateIfNeeded(_ layout: ILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
