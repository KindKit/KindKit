//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Custom {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Custom
        typealias Content = KKCustomView

        static var reuseIdentificator: String {
            return "UI.View.Custom"
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

final class KKCustomView : NSView {
    
    weak var kkDelegate: KKCustomViewDelegate?
    var kkLayoutManager: UI.Layout.Manager!
    var kkGestures: [IUIGesture] = []
    var kkDragDestination: IUIDragAndDropDestination?
    var kkDragSource: IUIDragAndDropSource? {
        willSet {
            guard self.kkDragSource !== newValue else { return }
            self.unregisterDraggedTypes()
        }
        didSet {
            guard self.kkDragSource !== oldValue else { return }
            if let dragSource = self.kkDragSource {
                self.registerForDraggedTypes(dragSource.pasteboardTypes)
            }
        }
    }
    var kkContentSize: Size {
        return self.kkLayoutManager.size
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
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        self.kkLayoutManager = .init(
            delegate: self,
            view: self
        )
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillMove(toSuperview superview: NSView?) {
        super.viewWillMove(toSuperview: superview)
        
        if superview == nil {
            self.kkLayoutManager.clear()
        }
    }
    
    override func layout() {
        super.layout()
        
        self.kkLayoutManager.visibleFrame = .init(self.bounds)
        self.kkLayoutManager.updateIfNeeded()
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard self.kkIsLocked == false else {
            return nil
        }
        let hitView = super.hitTest(point)
        if hitView === self {
            if self.kkDelegate?.hasHit(self, point: .init(point)) == false {
                return nil
            }
        }
        return hitView
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if let dragSource = self.kkDragSource {
            self.beginDraggingSession(
                with: dragSource.onItems.emit(default: []).compactMap({
                    return NSDraggingItem(pasteboardWriter: $0)
                }),
                event: event,
                source: self
            )
        }
    }
    
}

extension KKCustomView {
    
    func update(view: UI.View.Custom) {
        self.update(frame: view.frame)
        self.update(gestures: view.gestures)
        self.update(content: view.content)
        self.update(dragDestination: view.dragDestination)
        self.update(dragSource: view.dragSource)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(gestures: [IUIGesture]) {
        for gesture in self.kkGestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self.kkGestures = gestures
        for gesture in self.kkGestures {
            self.addGestureRecognizer(gesture.native)
        }
    }
    
    func update(content: IUILayout?) {
        self.kkLayoutManager.layout = content
        self.needsLayout = true
    }
    
    func update(dragDestination: IUIDragAndDropDestination?) {
        self.kkDragDestination = dragDestination
    }
    
    func update(dragSource: IUIDragAndDropSource?) {
        self.kkDragSource = dragSource
    }
    
    func update(color: UI.Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.kkIsLocked = locked
    }
    
    func cleanup() {
        self.kkLayoutManager.layout = nil
        for gesture in self.kkGestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self.kkGestures.removeAll()
        self.kkDelegate = nil
    }
    
    func add(gesture: IUIGesture) {
        if self.kkGestures.contains(where: { $0 === gesture }) == false {
            self.kkGestures.append(gesture)
        }
        self.addGestureRecognizer(gesture.native)
    }
    
    func remove(gesture: IUIGesture) {
        if let index = self.kkGestures.firstIndex(where: { $0 === gesture }) {
            self.kkGestures.remove(at: index)
        }
        self.removeGestureRecognizer(gesture.native)
    }
    
}

extension KKCustomView : NSDraggingSource {
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .generic
    }
    
}

extension KKCustomView {
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard self.kkDragDestination != nil else { return false }
        return true
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .generic
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
    }
}

extension KKCustomView : IUILayoutDelegate {
    
    func setNeedUpdate(_ layout: IUILayout) -> Bool {
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
    
    func updateIfNeeded(_ layout: IUILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
