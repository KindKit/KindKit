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
    var contentSize: Size {
        return self._layoutManager.size
    }
    override var bounds: CGRect {
        didSet {
            guard self.bounds != oldValue else { return }
            if self.bounds.size != oldValue.size {
                if self.window != nil {
                    self._layoutManager.invalidate()
                }
            }
        }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private var _layoutManager: UI.Layout.Manager!
    private var _gestures: [IUIGesture] = []
    private var _isLocked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        
        self._layoutManager = UI.Layout.Manager(contentView: self, delegate: self)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillMove(toSuperview superview: NSView?) {
        super.viewWillMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    override func layout() {
        super.layout()
        
        let bounds = Rect(self.bounds)
        self._layoutManager.layout(bounds: bounds)
        self._layoutManager.visible(bounds: bounds)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard self._isLocked == false else {
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
    
}

extension KKCustomView {
    
    func update(view: UI.View.Custom) {
        self.update(frame: view.frame)
        self.update(gestures: view.gestures)
        self.update(content: view.content)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(gestures: [IUIGesture]) {
        for gesture in self._gestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self._gestures = gestures
        for gesture in self._gestures {
            self.addGestureRecognizer(gesture.native)
        }
    }
    
    func update(content: IUILayout?) {
        self._layoutManager.layout = content
        self.needsLayout = true
    }
    
    func update(color: UI.Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self._isLocked = locked
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        for gesture in self._gestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self._gestures.removeAll()
        self.kkDelegate = nil
    }
    
    func add(gesture: IUIGesture) {
        if self._gestures.contains(where: { $0 === gesture }) == false {
            self._gestures.append(gesture)
        }
        self.addGestureRecognizer(gesture.native)
    }
    
    func remove(gesture: IUIGesture) {
        if let index = self._gestures.firstIndex(where: { $0 === gesture }) {
            self._gestures.remove(at: index)
        }
        self.removeGestureRecognizer(gesture.native)
    }
    
}

extension KKCustomView : IUILayoutDelegate {
    
    func setNeedUpdate(_ layout: IUILayout) -> Bool {
        self.needsLayout = true
        return true
    }
    
    func updateIfNeeded(_ layout: IUILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
