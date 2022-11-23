//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Control {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Control
        typealias Content = KKControlView

        static var reuseIdentificator: String {
            return "UI.View.Control"
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

final class KKControlView : NSControl {
        
    weak var kkDelegate: KKControlViewDelegate?
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
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        
        self._layoutManager = UI.Layout.Manager(contentView: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillMove(toSuperview newSuperview: NSView?) {
        super.viewWillMove(toSuperview: newSuperview)
        
        if self.superview == nil {
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
        guard let kkDelegate = self.kkDelegate else {
            return super.hitTest(point)
        }
        if kkDelegate.shouldHighlighting(self) == true || kkDelegate.shouldPressing(self) == true {
            return super.hitTest(point)
        }
        if let hitView = super.hitTest(point) {
            if hitView != self {
                return hitView
            }
        }
        return nil
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if let kkDelegate = self.kkDelegate {
            if kkDelegate.shouldHighlighting(self) == true {
                kkDelegate.set(self, highlighted: true)
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        if let kkDelegate = self.kkDelegate {
            let location = self.convert(event.locationInWindow, from: nil)
            if kkDelegate.shouldPressing(self) == true && self.bounds.contains(location) == true {
                kkDelegate.pressed(self)
            }
            if kkDelegate.shouldHighlighting(self) == true {
                kkDelegate.set(self, highlighted: false)
            }
        }
    }
    
}

extension KKControlView {
    
    func update(view: UI.View.Control) {
        self.update(frame: view.frame)
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
        self.isEnabled = locked == false
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.kkDelegate = nil
    }
    
}

extension KKControlView : IUILayoutDelegate {
    
    func setNeedUpdate(_ layout: IUILayout) -> Bool {
        self.needsLayout = true
        return true
    }
    
    func updateIfNeeded(_ layout: IUILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
