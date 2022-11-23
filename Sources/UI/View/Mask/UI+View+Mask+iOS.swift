//
//  KindKit
//

#if os(iOS)

import UIKit

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

final class KKMaskView : UIView {
        
    var contentSize: Size {
        return self._layoutManager.size
    }
    override var bounds: CGRect {
        didSet {
            guard self.bounds != oldValue else { return }
            if self.bounds.size != oldValue.size {
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
                if self.window != nil {
                    self._layoutManager.invalidate()
                }
            }
        }
    }
    
    private weak var _view: UI.View.Mask?
    private var _layoutManager: UI.Layout.Manager!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self._layoutManager = UI.Layout.Manager(contentView: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = Rect(self.bounds)
        self._layoutManager.layout(bounds: bounds)
        self._layoutManager.visible(bounds: bounds)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView === self {
            return nil
        }
        return hitView
    }

}

extension KKMaskView {
    
    func update(view: UI.View.Mask) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(color: view.color)
        self.update(layout: view.layout)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self._view = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(layout: IUILayout) {
        self._layoutManager.layout = layout
        self.setNeedsLayout()
    }
    
    func update(border: UI.Border) {
        let layer = self.layer
        switch border {
        case .none:
            layer.borderWidth = 0
            layer.borderColor = nil
        case .manual(let width, let color):
            layer.borderWidth = CGFloat(width)
            layer.borderColor = color.cgColor
        }
    }
    
    func update(cornerRadius: UI.CornerRadius) {
        let layer = self.layer
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
        let layer = self.layer
        if let shadow = shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowOpacity = Float(shadow.opacity)
            layer.shadowRadius = CGFloat(shadow.radius)
            layer.shadowOffset = CGSize(
                width: CGFloat(shadow.offset.x),
                height: CGFloat(shadow.offset.y)
            )
            self.clipsToBounds = false
        } else {
            layer.shadowColor = nil
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
            layer.shadowOffset = .zero
            self.clipsToBounds = true
        }
    }
    
    func updateShadowPath() {
        let layer = self.layer
        if layer.shadowColor != nil {
            layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: layer.cornerRadius, cornerHeight: layer.cornerRadius, transform: nil)
        } else {
            layer.shadowPath = nil
        }
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self._view = nil
    }
    
}

extension KKMaskView : IUILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: IUILayout) -> Bool {
        self.setNeedsLayout()
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: IUILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
