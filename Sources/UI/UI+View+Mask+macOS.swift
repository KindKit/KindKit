//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Mask {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Mask
        typealias Content = KKMaskView

        static var reuseIdentificator: String {
            return "UI.View.Mask"
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

final class KKMaskView : NSView {
        
    var contentSize: SizeFloat {
        return self._layoutManager.size
    }
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.update(cornerRadius: view.cornerRadius)
                self.updateShadowPath()
            }
        }
        get { super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private unowned var _view: UI.View.Mask?
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
    
    override func viewWillMove(toSuperview superview: NSView?) {
        super.viewWillMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    override func layout() {
        super.layout()
        
        let bounds = RectFloat(self.bounds)
        self._layoutManager.layout(bounds: bounds)
        self._layoutManager.visible(bounds: bounds)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if let hitView = super.hitTest(point) {
            if hitView === self {
                return nil
            }
        }
        return nil
    }
    
}

extension KKMaskView {
    
    func update(view: UI.View.Mask) {
        self._view = view
        self.update(color: view.color)
        self.update(layout: view.layout)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(layout: IUILayout) {
        self._layoutManager.layout = layout
        self.needsLayout = true
    }
    
    func update(color: UI.Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(border: UI.Border) {
        guard let layer = self.layer else { return }
        switch border {
        case .none:
            layer.borderWidth = 0
            layer.borderColor = nil
            break
        case .manual(let width, let color):
            layer.borderWidth = CGFloat(width)
            layer.borderColor = color.cgColor
            break
        }
    }
    
    func update(cornerRadius: UI.CornerRadius) {
        guard let layer = self.layer else { return }
        switch cornerRadius {
        case .none:
            layer.cornerRadius = 0
            layer.maskedCorners = [ .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner ]
        case .auto(let percent, let edges):
            let size = self.bounds.size
            if size.width > 0 && size.height > 0 {
                layer.cornerRadius = ceil(min(size.width - 1, size.height - 1)) * CGFloat(percent.value)
            } else {
                layer.cornerRadius = 0
            }
            layer.maskedCorners = edges.caCornerMask
        case .manual(let radius, let edges):
            layer.cornerRadius = CGFloat(radius)
            layer.maskedCorners = edges.caCornerMask
        }
    }
    
    func update(shadow: UI.Shadow?) {
        guard let layer = self.layer else { return }
        if let shadow = shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowOpacity = Float(shadow.opacity)
            layer.shadowRadius = CGFloat(shadow.radius)
            layer.shadowOffset = CGSize(
                width: CGFloat(shadow.offset.x),
                height: CGFloat(shadow.offset.y)
            )
            layer.masksToBounds = false
        } else {
            layer.shadowColor = nil
            layer.masksToBounds = false
        }
    }
    
    func updateShadowPath() {
        guard let layer = self.layer else { return }
        if layer.shadowColor != nil {
            layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: layer.cornerRadius, cornerHeight: layer.cornerRadius, transform: nil)
        } else {
            layer.shadowPath = nil
        }
    }
    
    func update(alpha: Float) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self._view = nil
    }
    
}

extension KKMaskView : IUILayoutDelegate {
    
    func setNeedUpdate(_ layout: IUILayout) -> Bool {
        self.needsLayout = true
        return true
    }
    
    func updateIfNeeded(_ layout: IUILayout) {
        self.layoutSubtreeIfNeeded()
    }
    
}

#endif
