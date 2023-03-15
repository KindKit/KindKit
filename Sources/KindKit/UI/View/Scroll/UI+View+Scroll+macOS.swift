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
    
    weak var kkDelegate: KKScrollViewDelegate?
    var needLayoutContent: Bool = true {
        didSet {
            if self.needLayoutContent == true {
                self._documentView.needsLayout = true
                self.contentView.needsLayout = true
            }
        }
    }
    override var contentSize: CGSize {
        set { self._documentView.frame = NSRect(origin: .zero, size: newValue) }
        get { super.contentSize }
    }
    override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            if self.frame.size != oldValue.size {
                if self.window != nil {
                    self._layoutManager.invalidate()
                }
                self.needLayoutContent = true
            }
        }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private var _contentView: KKScrollContentView!
    private var _documentView: KKScrollDocumentView!
    private var _layoutManager: UI.Layout.Manager!
    private var _visibleInset: Inset = .zero {
        didSet {
            guard self._visibleInset != oldValue else { return }
            self.needLayoutContent = true
        }
    }
    private var _isLocked: Bool = false
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self._contentView = KKScrollContentView(owner: self)
        self._documentView = KKScrollDocumentView(owner: self)
        
        self.contentView = self._contentView
        self.documentView = self._documentView
        self.translatesAutoresizingMaskIntoConstraints = false
        self.drawsBackground = true
        self.autohidesScrollers = true
        self.automaticallyAdjustsContentInsets = false
        self.wantsLayer = true
        
        self._layoutManager = .init(contentView: self._documentView, delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self._startDragging(_:)), name: Self.willStartLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._dragging(_:)), name: Self.didLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._endDragging(_:)), name: Self.didEndLiveScrollNotification, object: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillMove(toSuperview superview: NSView?) {
        super.viewWillMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard self._isLocked == false else {
            return nil
        }
        return super.hitTest(point)
    }
    
    func layoutContent() {
        if self.needLayoutContent == true {
            let bounds = Rect(self.bounds)
            self._layoutManager.layout(bounds: bounds)
            self.contentSize = self._layoutManager.size.cgSize
            self.kkDelegate?.update(self, contentSize: self._layoutManager.size)
            self.needLayoutContent = false
        }
        do {
            let visibleRect = Rect(self.contentView.documentVisibleRect)
            self._layoutManager.visible(bounds: visibleRect, inset: self._visibleInset)
        }
    }
    
}

final class KKScrollContentView : NSClipView {
    
    override var isFlipped: Bool {
        return true
    }
    
    unowned var _owner: KKScrollView

    init(owner: KKScrollView) {
        self._owner = owner
        
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func scroll(to newOrigin: NSPoint) {
        super.scroll(to: newOrigin)
        
        self._owner.layoutContent()
    }
    
}

final class KKScrollDocumentView : NSView {
    
    override var isFlipped: Bool {
        return true
    }
    
    unowned var _owner: KKScrollView

    init(owner: KKScrollView) {
        self._owner = owner
        
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
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
        self.update(frame: view.frame)
        self.update(direction: view.direction)
        self.update(indicatorDirection: view.indicatorDirection)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(contentOffset: view.contentOffset, normalized: true)
        self.update(content: view.content)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(content: IUILayout?) {
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
    
    func update(visibleInset: Inset) {
        self._visibleInset = visibleInset
    }
    
    func update(contentInset: Inset) {
        self.contentInsets = contentInset.nsEdgeInsets
    }
    
    func update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentOffset: Point, normalized: Bool) {
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
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native ?? .clear
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self._isLocked = locked
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.kkDelegate = nil
    }
    
}

private extension KKScrollView {
    
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
