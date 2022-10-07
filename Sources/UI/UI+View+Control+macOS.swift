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
        
    unowned var kkDelegate: KKControlViewDelegate?
    var contentSize: SizeFloat {
        return self._layoutManager.size
    }
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private unowned var _view: UI.View.Control?
    private var _layoutManager: UI.Layout.Manager!
    private var _isLayout: Bool
    
    override init(frame: CGRect) {
        self._isLayout = false
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        self._safeLayout({
            let bounds = RectFloat(self.bounds)
            self._layoutManager.layout(bounds: bounds)
            self._layoutManager.visible(bounds: bounds)
        })
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
            let location = self.convert(event.locationInWindow, to: self)
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
        self._view = view
        self.update(content: view.content)
        self.update(locked: view.isLocked)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(content: IUILayout) {
        self._layoutManager.layout = content
        self.needsLayout = true
    }
    
    func update(locked: Bool) {
        self.isEnabled = locked == false
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKControlView {
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
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
