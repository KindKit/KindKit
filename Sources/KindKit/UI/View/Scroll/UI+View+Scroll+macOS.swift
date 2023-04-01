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
    var kkNeedLayoutContent: Bool = true {
        didSet {
            if self.kkNeedLayoutContent == true {
                self.kkDocumentView.needsLayout = true
                self.kkContentView.needsLayout = true
            }
        }
    }
    var kkContentView: KKScrollContentView!
    var kkDocumentView: KKScrollDocumentView!
    var kkLayoutManager: UI.Layout.Manager!
    var kkVisibleInset: Inset = .zero {
        didSet {
            guard self.kkVisibleInset != oldValue else { return }
            self.kkNeedLayoutContent = true
        }
    }
    var kkIsLocked: Bool = false
    
    override var isFlipped: Bool {
        return true
    }
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
        set { self.kkDocumentView.frame = NSRect(origin: .zero, size: newValue) }
        get { super.contentSize }
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.kkContentView = KKScrollContentView(owner: self)
        self.kkDocumentView = KKScrollDocumentView(owner: self)
        
        self.contentView = self.kkContentView
        self.documentView = self.kkDocumentView
        self.drawsBackground = true
        self.autohidesScrollers = true
        self.automaticallyAdjustsContentInsets = false
        self.wantsLayer = true
        
        self.kkLayoutManager = .init(contentView: self.kkDocumentView, delegate: self)
        
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
            self.kkLayoutManager.clear()
        }
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard self.kkIsLocked == false else {
            return nil
        }
        return super.hitTest(point)
    }
    
    func layoutContent() {
        if self.kkNeedLayoutContent == true {
            let bounds = Rect(self.bounds)
            self.kkLayoutManager.layout(bounds: bounds)
            self.contentSize = self.kkLayoutManager.size.cgSize
            self.kkDelegate?.update(self, contentSize: self.kkLayoutManager.size)
            self.kkNeedLayoutContent = false
        }
        do {
            let visibleRect = Rect(self.contentView.documentVisibleRect)
            self.kkLayoutManager.visible(bounds: visibleRect, inset: self.kkVisibleInset)
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
    
    func contentOffset(
        with view: NSView,
        horizontal: UI.View.Scroll.ScrollAlignment,
        vertical: UI.View.Scroll.ScrollAlignment
    ) -> CGPoint? {
        let contentInset = self.contentInsets
        let contentSize = self.contentSize
        let visibleSize = self.bounds.size
        let viewFrame = Rect(self.convert(view.frame, from: view))
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
        self.kkLayoutManager.layout = content
        self.kkNeedLayoutContent = true
    }
    
    func update(direction: UI.View.Scroll.Direction) {
        self.horizontalScrollElasticity = direction.contains(.horizontal) && direction.contains(.bounds) ? .allowed : .none
        self.verticalScrollElasticity = direction.contains(.vertical) && direction.contains(.bounds) ? .allowed : .none
        self.kkNeedLayoutContent = true
    }
    
    func update(indicatorDirection: UI.View.Scroll.Direction) {
        self.hasHorizontalScroller = indicatorDirection.contains(.horizontal)
        self.hasVerticalScroller = indicatorDirection.contains(.vertical)
    }
    
    func update(visibleInset: Inset) {
        self.kkVisibleInset = visibleInset
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
        self.kkIsLocked = locked
    }
    
    func cleanup() {
        self.kkLayoutManager.layout = nil
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
        self.kkNeedLayoutContent = true
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
