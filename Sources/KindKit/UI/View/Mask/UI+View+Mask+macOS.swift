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
    
    weak var kkDelegate: KKMaskViewDelegate?
    var kkBorder: UI.Border {
        set { self.kkClipView.kkBorder = newValue }
        get { self.kkClipView.kkBorder }
    }
    var kkCornerRadius: UI.CornerRadius {
        set { self.kkClipView.kkCornerRadius = newValue }
        get { self.kkClipView.kkCornerRadius }
    }
    var kkShadow: UI.Shadow? {
        didSet {
            guard self.kkShadow != oldValue else { return }
            if let layer = self.layer {
                if let shadow = self.kkShadow {
                    layer.masksToBounds = false
                    layer.shadowColor = shadow.color.cgColor
                    layer.shadowOpacity = Float(shadow.opacity)
                    layer.shadowRadius = CGFloat(shadow.radius)
                    layer.shadowOffset = CGSize(
                        width: CGFloat(shadow.offset.x),
                        height: CGFloat(shadow.offset.y)
                    )
                } else {
                    layer.masksToBounds = true
                    layer.shadowColor = nil
                    layer.shadowOpacity = 0
                    layer.shadowRadius = 0
                    layer.shadowOffset = .zero
                }
            }
            self._updatePath()
        }
    }
    var kkLayoutManager: UI.Layout.Manager!
    var kkClipView: KKClipView
    
    override var isFlipped: Bool {
        return true
    }
    override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            if self.frame.size != oldValue.size {
                self.kkClipView.frame = .init(
                    origin: .zero,
                    size: frame.size
                )
                self._updatePath()
                if self.window != nil {
                    self.kkLayoutManager.invalidate()
                }
            }
        }
    }
    
    override init(frame: NSRect) {
        self.kkClipView = KKClipView(frame: .init(
            origin: .zero,
            size: frame.size
        ))
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        self.addSubview(self.kkClipView)
        
        self.kkLayoutManager = .init(
            delegate: self,
            view: self.kkClipView
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
        if let hitView = super.hitTest(point) {
            if hitView === self {
                return nil
            }
        }
        return nil
    }
    
}

extension KKMaskView {
    
    final class KKClipView : NSView {
        
        override var isFlipped: Bool {
            return true
        }
        override var frame: CGRect {
            didSet {
                guard self.frame != oldValue else { return }
                if self.frame.size != oldValue.size {
                    self._updatePath()
                }
            }
        }
        
        var kkBorder: UI.Border = .none {
            didSet {
                guard self.kkBorder != oldValue else { return }
                switch self.kkBorder {
                case .none:
                    self.kkBorderLayer.lineWidth = 0
                    self.kkBorderLayer.strokeColor = nil
                case .manual(let width, let color):
                    self.kkBorderLayer.lineWidth = CGFloat(width)
                    self.kkBorderLayer.strokeColor = color.cgColor
                }
                self._updatePath()
            }
        }
        var kkCornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.kkCornerRadius != oldValue else { return }
                self._updatePath()
            }
        }
        var kkBorderLayer: CAShapeLayer
        var kkMaskLayer: CAShapeLayer
        
        override init(frame: CGRect) {
            self.kkBorderLayer = .init()
            self.kkBorderLayer.fillColor = nil
            self.kkBorderLayer.zPosition = 1
            
            self.kkMaskLayer = CAShapeLayer()
            
            super.init(frame: frame)
            
            self.wantsLayer = true
            self.layer?.mask = self.kkMaskLayer
            self.layer?.addSublayer(self.kkBorderLayer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
    
}

extension KKMaskView {
    
    func update(view: UI.View.Mask) {
        self.update(frame: view.frame)
        self.update(layout: view.layout)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(layout: IUILayout) {
        self.kkLayoutManager.layout = layout
        self.needsLayout = true
    }
    
    func update(border: UI.Border) {
        self.kkBorder = border
    }
    
    func update(cornerRadius: UI.CornerRadius) {
        self.kkCornerRadius = cornerRadius
    }
    
    func update(shadow: UI.Shadow?) {
        self.kkShadow = shadow
    }
    
    func update(color: UI.Color?) {
        guard let layer = self.kkClipView.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkLayoutManager.layout = nil
        self.kkDelegate = nil
    }
    
}

private extension KKMaskView {
    
    func _updatePath() {
        guard let layer = self.layer else { return }
        layer.shadowPath = CGPath.kk_roundRect(
            rect: Rect(self.bounds),
            corner: self.kkCornerRadius
        )
    }
    
}

private extension KKMaskView.KKClipView {
    
    func _updatePath() {
        self.kkBorderLayer.path = CGPath.kk_roundRect(
            rect: Rect(self.bounds),
            border: self.kkBorderLayer.lineWidth,
            corner: self.kkCornerRadius
        )
        self.kkMaskLayer.path = CGPath.kk_roundRect(
            rect: Rect(self.bounds),
            corner: self.kkCornerRadius
        )
    }
    
}

extension KKMaskView : IUILayoutDelegate {
    
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
