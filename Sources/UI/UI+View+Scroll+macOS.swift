//
//  KindKit
//

#if os(macOS)

import AppKit

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

final class KKScrollView : NSScrollView {
    
    unowned var kkDelegate: KKScrollViewDelegate?
    var needLayoutContent: Bool = true {
        didSet {
            if self.needLayoutContent == true {
                self.documentView?.needsLayout = true
                self.contentView.needsLayout = true
            }
        }
    }
    override var contentSize: CGSize {
        set {
            self.documentView?.frame = NSRect(origin: self.frame.origin, size: newValue)
        }
        get { return super.contentSize }
    }
    override var frame: CGRect {
        set {
            let oldValue = super.frame
            if oldValue != newValue {
                super.frame = newValue
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
                if oldValue.size != newValue.size {
                    self.needLayoutContent = true
                }
            }
        }
        get { return super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private unowned var _view: UI.View.Scroll?
    private var _layoutManager: UI.Layout.Manager!
    private var _visibleInset: InsetFloat = .zero {
        didSet {
            guard self._visibleInset != oldValue else { return }
            self.needLayoutContent = true
        }
    }
    private var _isLayout: Bool = false
    private var _isLocked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autohidesScrollers = true
        self.contentView = KKScrollContentView(owner: self)
        self.documentView = KKScrollDocumentView(owner: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self._startDragging(_:)), name: Self.willStartLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._dragging(_:)), name: Self.didLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._endDragging(_:)), name: Self.didEndLiveScrollNotification, object: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.documentView = nil
    }
    
    override func scrollWheel(with event: NSEvent) {
        if self._isLocked == false {
            super.scrollWheel(with: event)
        }
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
                self.kkDelegate?.update(self, contentSize: self._layoutManager.size)
            }
            self._layoutManager.visible(
                bounds: RectFloat(self.contentView.documentVisibleRect),
                inset: self._visibleInset
            )
        })
    }
    
}
    
final class KKScrollContentView : NSClipView {
    
    unowned var _owner: KKScrollView
    override var isFlipped: Bool {
        return true
    }

    init(owner: KKScrollView) {
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

final class KKScrollDocumentView : NSView {
    
    unowned var _owner: KKScrollView
    override var isFlipped: Bool {
        return true
    }

    init(owner: KKScrollView) {
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

extension KKScrollView {
    
    func update(view: UI.View.Scroll) {
        self._view = view
        self.update(direction: view.direction)
        self.update(indicatorDirection: view.indicatorDirection)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(contentOffset: view.contentOffset, normalized: true)
        self.update(content: view.content)
        self.update(locked: view.isLocked)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(locked: Bool) {
        self._isLocked = locked
    }
    
    func update(content: IUILayout) {
        self._layoutManager.layout = content
        self.needLayoutContent = true
    }
    
    func update(direction: UI.View.Scroll.Direction) {
        self.horizontalScrollElasticity = direction.contains(.horizontal) && direction.contains(.bounds) ? .allowed : .none
        self.verticalScrollElasticity = direction.contains(.vertical) && direction.contains(.bounds) ? .allowed : .none
        self.needLayoutContent = true
    }
    
    func update(indicatorDirection: UI.View.Scroll.Direction) {
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
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKScrollView {
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
    }
    
    @objc
    func _startDragging(_ sender: Any) {
        self.kkDelegate?.beginDragging(self)
    }
    
    @objc
    func _dragging(_ sender: Any) {
        self.kkDelegate?.dragging(self, contentOffset: Point(self.contentView.documentRect.origin))
    }
    
    @objc
    func _endDragging(_ sender: Any) {
        self.kkDelegate?.endDragging(self, decelerate: false)
    }
    
}

extension KKScrollView : IUILayoutDelegate {
    
    func setNeedUpdate(_ layout: IUILayout) -> Bool {
        self.needLayoutContent = true
        if let kkDelegate = self.kkDelegate {
            return kkDelegate.isDynamicSize(self)
        }
        return false
    }
    
    func updateIfNeeded(_ layout: IUILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
