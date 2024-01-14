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

        static var reuseIdentificator: String {
            return "RectView"
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
    
    func update(view: RectView) {
        self.update(frame: view.frame)
        self.update(color: view.color)
        self.update(fill: view.fill)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(color: Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(fill: Color?) {
        self.kkShareLayer.fillColor = fill?.cgColor
    }
    
    func update(border: Border) {
        switch border {
        case .none:
            self.kkBorderWidth = 0
            self.kkBorderColor = nil
        case .manual(let width, let color):
            self.kkBorderWidth = CGFloat(width)
            self.kkBorderColor = color.cgColor
        }
    }
    
    func update(cornerRadius: CornerRadius) {
        self.kkCornerRadius = cornerRadius
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
