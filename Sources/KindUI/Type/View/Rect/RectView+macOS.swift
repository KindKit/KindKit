//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension RectView {
    
    struct Reusable : IReusable {
        
        typealias Owner = RectView
        typealias Content = KKRectView
        
        static func name(owner: Owner) -> String {
            return "RectView"
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

final class KKRectView : NSView {
    
    var kkBorderWidth: CGFloat = 0 {
        didSet {
            guard self.kkBorderWidth != oldValue else { return }
            self.kkShareLayer.lineWidth = self.kkBorderWidth
            self.needsLayout = true
        }
    }
    var kkBorderColor: CGColor? {
        didSet {
            guard self.kkBorderColor != oldValue else { return }
            self.kkShareLayer.strokeColor = self.kkBorderColor
            self.needsLayout = true
        }
    }
    var kkCornerRadius: CornerRadius = .none {
        didSet {
            guard self.kkCornerRadius != oldValue else { return }
            self.needsLayout = true
        }
    }
    let kkShareLayer: CAShapeLayer
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        self.kkShareLayer = CAShapeLayer()
        self.kkShareLayer.contentsScale = NSScreen.main!.backingScaleFactor
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        self.layer?.addSublayer(self.kkShareLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    override func layout() {
        super.layout()
        
        self.kkShareLayer.path = CGPath.kk_roundRect(
            rect: Rect(self.bounds),
            border: self.kkBorderWidth,
            corner: self.kkCornerRadius
        )
    }
    
}

extension KKRectView {
    
    func kk_update(view: RectView) {
        self.kk_update(frame: view.frame)
        self.kk_update(color: view.color)
        self.kk_update(fill: view.fill)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(alpha: view.alpha)
    }
    
    func kk_cleanup(view: RectView) {
    }
    
}

extension KKRectView {
    
    func kk_update(color: Color) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color.native.cgColor
    }
    
    func kk_update(fill: Color) {
        self.kkShareLayer.fillColor = fill.cgColor
    }
    
    func kk_update(border: Border) {
        switch border {
        case .none:
            self.kkBorderWidth = 0
            self.kkBorderColor = nil
        case .manual(let width, let color):
            self.kkBorderWidth = CGFloat(width)
            self.kkBorderColor = color.cgColor
        }
    }
    
    func kk_update(cornerRadius: CornerRadius) {
        self.kkCornerRadius = cornerRadius
    }
    
    func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
}

#endif
