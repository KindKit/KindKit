//
//  KindKit
//

#if os(macOS)

import AppKit
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

final class KKScrollView : NSScrollView {
    
    weak var kkDelegate: KKScrollViewDelegate?
    let kkContentView = KKScrollContentView()
    let kkDocumentView = KKScrollDocumentView()
    var kkIsEnabled: Bool = true
    
    override var isFlipped: Bool {
        return true
    }
    override var contentSize: CGSize {
        set { self.kkDocumentView.frame = NSRect(origin: .zero, size: newValue) }
        get { super.contentSize }
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.contentView = self.kkContentView
        self.documentView = self.kkDocumentView
        self.drawsBackground = true
        self.autohidesScrollers = true
        self.automaticallyAdjustsContentInsets = false
        self.wantsLayer = true
        
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
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard self.kkIsEnabled == true else {
            return nil
        }
        return super.hitTest(point)
    }
    
}

final class KKScrollContentView : NSClipView {
    
    override var isFlipped: Bool {
        return true
    }
    
}

final class KKScrollDocumentView : NSView {
    
    override var isFlipped: Bool {
        return true
    }
    
}

extension KKScrollView {
    
    final func kk_update< LayoutType : ILayout >(view: ScrollView< LayoutType >) {
        self.kk_update(frame: view.frame)
        self.kk_update(bounce: view.bounce)
        self.kk_update(indicatorDirection: view.indicatorDirection)
        self.kk_update(adjustmentInset: view.adjustmentInset)
        self.kk_update(contentSize: view.contentSize)
        self.kk_update(contentOffset: view.contentOffset)
        self.kk_update(zoom: view.zoom, limit: view.zoomLimit)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kk_update(enabled: view.isEnabled)
        view.holder = LayoutHolder(self.kkDocumentView)
        self.kkDelegate = view
    }
    
    final func kk_cleanup< LayoutType : ILayout >(view: ScrollView< LayoutType >) {
        self.kkDelegate = nil
        view.holder = nil
    }
    
}

extension KKScrollView {
    
    final func kk_update(bounce: ScrollBounce) {
        self.horizontalScrollElasticity = bounce.contains(.horizontal) ? .allowed : .none
        self.verticalScrollElasticity = bounce.contains(.vertical) ? .allowed : .none
    }
    
    final func kk_update(indicatorDirection: ScrollDirection) {
        self.hasHorizontalScroller = indicatorDirection.contains(.horizontal)
        self.hasVerticalScroller = indicatorDirection.contains(.vertical)
    }
    
    final func kk_update(adjustmentInset: Inset) {
        self.contentInsets = adjustmentInset.nsEdgeInsets
    }
    
    final func kk_update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    final func kk_update(contentOffset: Point) {
        self.scroll(contentOffset.cgPoint)
    }
    
    final func kk_update(zoom: Double, limit: Range< Double >) {
        self.magnification = zoom
        self.minMagnification = limit.lowerBound
        self.maxMagnification = limit.upperBound
        self.allowsMagnification = limit.lowerBound < limit.upperBound
    }
    
    final func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    final func kk_update(enabled: Bool) {
        self.kkIsEnabled = enabled
    }
    
}

private extension KKScrollView {
    
    @objc
    func _startDragging(_ sender: Any) {
        self.kkDelegate?.kk_beginDragging(self)
    }
    
    @objc
    func _dragging(_ sender: Any) {
        self.kkDelegate?.kk_update(self, contentOffset: Point(self.contentView.documentRect.origin))
    }
    
    @objc
    func _endDragging(_ sender: Any) {
        self.kkDelegate?.kk_endDragging(self, decelerate: false)
    }
    
    @objc
    func _startZooming(_ sender: Any) {
        self.kkDelegate?.kk_beginZooming(self)
    }
    
    @objc
    func _zooming(_ sender: Any) {
        self.kkDelegate?.kk_update(self, zoom: Double(self.magnification))
    }
    
    @objc
    func _endZooming(_ sender: Any) {
        self.kkDelegate?.kk_endZooming(self)
    }
    
}

#endif
