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
    override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            if self.frame.size != oldValue.size {
                self._clipView.frame = .init(
                    origin: .zero,
                    size: frame.size
                )
                self._updatePath()
                if self.window != nil {
                    self._layoutManager.invalidate()
                }
            }
        }
    }
    
    fileprivate var _border: UI.Border = .none {
        didSet {
            guard self._border != oldValue else { return }
            self._clipView._border = self._border
        }
    }
    fileprivate var _cornerRadius: UI.CornerRadius = .none {
        didSet {
            guard self._cornerRadius != oldValue else { return }
            self._updatePath()
            self._clipView._cornerRadius = self._cornerRadius
        }
    }
    fileprivate var _shadow: UI.Shadow? {
        didSet {
            guard self._shadow != oldValue else { return }
            if let shadow = self._shadow {
                self.layer.shadowColor = shadow.color.cgColor
                self.layer.shadowOpacity = Float(shadow.opacity)
                self.layer.shadowRadius = CGFloat(shadow.radius)
                self.layer.shadowOffset = CGSize(
                    width: CGFloat(shadow.offset.x),
                    height: CGFloat(shadow.offset.y)
                )
            } else {
                self.layer.shadowColor = nil
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowOffset = .zero
            }
            self._updatePath()
        }
    }
    fileprivate var _layoutManager: UI.Layout.Manager!
    fileprivate var _clipView: ClipView
    
    override init(frame: CGRect) {
        self._clipView = .init(frame: .init(
            origin: .zero,
            size: frame.size
        ))
        
        super.init(frame: frame)
        
        self.clipsToBounds = false
        self.addSubview(self._clipView)
        
        self._layoutManager = UI.Layout.Manager(
            contentView: self._clipView,
            delegate: self
        )
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
    
    final class ClipView : UIView {
        
        override var frame: CGRect {
            didSet {
                guard self.frame != oldValue else { return }
                if self.frame.size != oldValue.size {
                    self._updatePath()
                }
            }
        }
        
        fileprivate var _border: UI.Border = .none {
            didSet {
                guard self._border != oldValue else { return }
                switch self._border {
                case .none:
                    self._borderLayer.lineWidth = 0
                    self._borderLayer.strokeColor = nil
                case .manual(let width, let color):
                    self._borderLayer.lineWidth = CGFloat(width)
                    self._borderLayer.strokeColor = color.cgColor
                }
                self._updatePath()
            }
        }
        fileprivate var _cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self._cornerRadius != oldValue else { return }
                self._updatePath()
            }
        }
        fileprivate var _borderLayer: CAShapeLayer
        fileprivate var _maskLayer: CAShapeLayer
        
        override init(frame: CGRect) {
            self._borderLayer = .init()
            self._borderLayer.fillColor = nil
            self._borderLayer.zPosition = 1
            
            self._maskLayer = .init()
            
            super.init(frame: frame)
            
            self.clipsToBounds = false
            
            self.layer.mask = self._maskLayer
            self.layer.addSublayer(self._borderLayer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let hitView = super.hitTest(point, with: event)
            if hitView === self {
                return nil
            }
            return hitView
        }

    }
    
}

extension KKMaskView {
    
    func update(view: UI.View.Mask) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(layout: view.layout)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
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
        self._border = border
    }
    
    func update(cornerRadius: UI.CornerRadius) {
        self._cornerRadius = cornerRadius
    }
    
    func update(shadow: UI.Shadow?) {
        self._shadow = shadow
    }
    
    func update(color: UI.Color?) {
        self._clipView.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
    }
    
}

private extension KKMaskView {
    
    func _updatePath() {
        self.layer.shadowPath = CGPath.kk_roundRect(
            rect: Rect(self.bounds),
            corner: self._cornerRadius
        )
    }
    
}

private extension KKMaskView.ClipView {
    
    func _updatePath() {
        self._borderLayer.path = CGPath.kk_roundRect(
            rect: Rect(self.bounds),
            border: self._borderLayer.lineWidth,
            corner: self._cornerRadius
        )
        self._maskLayer.path = CGPath.kk_roundRect(
            rect: Rect(self.bounds),
            corner: self._cornerRadius
        )
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
