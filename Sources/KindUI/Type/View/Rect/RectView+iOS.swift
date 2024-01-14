//
//  KindKit
//

#if os(iOS)

import UIKit
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

final class KKRectView : UIView {
    
    var kkBorderWidth: CGFloat = 0 {
        didSet {
            guard self.kkBorderWidth != oldValue else { return }
            CATransaction.kk_withoutActions({
                self.kkShareLayer.lineWidth = self.kkBorderWidth
            })
            self.setNeedsLayout()
        }
    }
    var kkBorderColor: CGColor? {
        didSet {
            guard self.kkBorderColor != oldValue else { return }
            CATransaction.kk_withoutActions({
                self.kkShareLayer.strokeColor = self.kkBorderColor
            })
            self.setNeedsLayout()
        }
    }
    var kkCornerRadius: CornerRadius = .none {
        didSet {
            guard self.kkCornerRadius != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    let kkShareLayer: CAShapeLayer
        
    override init(frame: CGRect) {
        self.kkShareLayer = CAShapeLayer()
        self.kkShareLayer.contentsScale = UIScreen.main.scale
        
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        
        self.layer.addSublayer(self.kkShareLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.kk_withoutActions({
            self.kkShareLayer.path = CGPath.kk_roundRect(
                rect: Rect(self.bounds),
                border: self.kkBorderWidth,
                corner: self.kkCornerRadius
            )
        })
    }
    
}

extension KKRectView {
    
    func update(view: RectView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(fill: view.fill)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(fill: Color?) {
        CATransaction.kk_withoutActions({
            self.kkShareLayer.fillColor = fill?.cgColor
        })
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
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
