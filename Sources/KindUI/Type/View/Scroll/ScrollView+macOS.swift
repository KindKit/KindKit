//
//  KindKit
//

#if os(macOS)

import AppKit
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

final class KKScrollView : NSScrollView {
    
    weak var kkDelegate: KKScrollViewDelegate?
    var kkContentView: KKScrollContentView!
    var kkDocumentView: KKScrollDocumentView!
    var kkLayoutManager: LayoutManager!
    var kkContentSize: CGSize = .zero {
        didSet {
            guard self.kkContentSize != oldValue else { return }
            self.contentSize = .init(
                width: self.kkContentSize.width * self.magnification,
                height: self.kkContentSize.height * self.magnification
            )
            self.kkDelegate?.update(self, contentSize: .init(self.kkContentSize))
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
                self.kkDocumentView.needsLayout = true
                self.kkContentView.needsLayout = true
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
        
        self.kkLayoutManager = .init(
            delegate: self,
            view: self.kkDocumentView
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(self._startDragging(_:)), name: Self.willStartLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._dragging(_:)), name: Self.didLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._endDragging(_:)), name: Self.didEndLiveScrollNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._startZooming(_:)), name: Self.willStartLiveMagnifyNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._zooming(_:)), name: Self.didEndLiveMagnifyNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self._endZooming(_:)), name: Self.didEndLiveMagnifyNotification, object: self)
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
            self.kkDocumentView.needsLayout = true
            self.kkContentView.needsLayout = true
        }
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard self.kkIsLocked == false else {
            return nil
        }
        return super.hitTest(point)
    }
    
    func layoutContent() {
        self.kkLayoutManager.visibleFrame = .init(self.documentVisibleRect)
        self.kkLayoutManager.updateIfNeeded()
        self.kkContentSize = self.kkLayoutManager.size.cgSize
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
        horizontal: ScrollView.ScrollAlignment,
        vertical: ScrollView.ScrollAlignment
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
    
    func update(view: ScrollView) {
        self.update(frame: view.frame)
        self.update(bounce: view.bounce)
        self.update(direction: view.direction)
        self.update(indicatorDirection: view.indicatorDirection)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(contentOffset: view.contentOffset)
        self.update(zoom: view.zoom, limit: view.zoomLimit)
        self.update(content: view.content)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(content: ILayout?) {
        self.kkLayoutManager.layout = content
        self.kkDocumentView.needsLayout = true
        self.kkContentView.needsLayout = true
    }
    
    func update(bounce: ScrollView.Bounce) {
        self.horizontalScrollElasticity = bounce.contains(.horizontal) ? .allowed : .none
        self.verticalScrollElasticity = bounce.contains(.vertical) ? .allowed : .none
    }
    
    func update(direction: ScrollView.Direction) {
    }
    
    func update(indicatorDirection: ScrollView.Direction) {
        self.hasHorizontalScroller = indicatorDirection.contains(.horizontal)
        self.hasVerticalScroller = indicatorDirection.contains(.vertical)
    }
    
    func update(visibleInset: Inset) {
        self.kkLayoutManager.preloadInsets = visibleInset
    }
    
    func update(contentInset: Inset) {
        self.contentInsets = contentInset.nsEdgeInsets
    }
    
    func update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentOffset: Point) {
        self.scroll(contentOffset.cgPoint)
    }
    
    func update(zoom: Double, limit: Range< Double >) {
        self.magnification = zoom
        self.minMagnification = limit.lowerBound
        self.maxMagnification = limit.upperBound
        self.allowsMagnification = limit.lowerBound < limit.upperBound
    }
    
    func update(color: Color?) {
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
    
    @objc
    func _startZooming(_ sender: Any) {
        self.kkDelegate?.beginZooming(self)
    }
    
    @objc
    func _zooming(_ sender: Any) {
        self.kkDelegate?.zooming(self, zoom: Double(self.magnification))
    }
    
    @objc
    func _endZooming(_ sender: Any) {
        self.kkDelegate?.endZooming(self)
    }
    
}

extension KKScrollView : ILayoutDelegate {
    
    func setNeedUpdate(_ layout: ILayout) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        defer {
            self.needsLayout = true
        }
        guard delegate.isDynamic(self) == true else {
            self.kkLayoutManager.setNeed(layout: true)
            return false
        }
        self.kkLayoutManager.setNeed(layout: true)
        return true
    }
    
    func updateIfNeeded(_ layout: ILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
