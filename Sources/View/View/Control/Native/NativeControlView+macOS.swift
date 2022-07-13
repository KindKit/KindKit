//
//  KindKitView
//

#if os(macOS)

import AppKit
import KindKitCore
import KindKitMath

extension ControlView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ControlView
        typealias Content = NativeControlView

        static var reuseIdentificator: String {
            return "ControlView"
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

final class NativeControlView : NSControl {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: NativeControlViewDelegate?
    var contentSize: SizeFloat {
        return self._layoutManager.size
    }
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
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
    private var _isLayout: Bool
    
    override init(frame: CGRect) {
        self._isLayout = false
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self._layoutManager = LayoutManager(contentView: self, delegate: self)
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
        guard let customDelegate = self.customDelegate else {
            return super.hitTest(point)
        }
        if customDelegate.shouldHighlighting(view: self) == true || customDelegate.shouldPressing(view: self) == true {
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
        
        if let customDelegate = self.customDelegate {
            if customDelegate.shouldHighlighting(view: self) == true {
                customDelegate.set(view: self, highlighted: true)
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        if let customDelegate = self.customDelegate {
            let location = self.convert(event.locationInWindow, to: self)
            if customDelegate.shouldPressing(view: self) == true && self.bounds.contains(location) == true {
                customDelegate.pressed(view: self)
            }
            if customDelegate.shouldHighlighting(view: self) == true {
                customDelegate.set(view: self, highlighted: false)
            }
        }
    }
    
}

extension NativeControlView {
    
    func update< Layout : ILayout >(view: ControlView< Layout >) {
        self._view = view
        self.update(contentLayout: view.contentLayout)
        self.update(locked: view.isLocked)
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
        self.needsLayout = true
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativeControlView {
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
    }
    
}

extension NativeControlView : ILayoutDelegate {
    
    func setNeedUpdate(_ layout: ILayout) -> Bool {
        self.needsLayout = true
        return true
    }
    
    func updateIfNeeded(_ layout: ILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
