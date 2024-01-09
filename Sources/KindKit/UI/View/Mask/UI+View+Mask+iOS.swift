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
    
    weak var kkDelegate: KKMaskViewDelegate?
    var kkContentSize: Size {
        return self.kkLayoutManager.size
    }
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
            if let shadow = self.kkShadow {
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
    var kkLayoutManager: UI.Layout.Manager!
    let kkClipView: KKClipView
    
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
    
    override init(frame: CGRect) {
        self.kkClipView = .init(frame: .init(
            origin: .zero,
            size: frame.size
        ))
        
        super.init(frame: frame)
        
        self.clipsToBounds = false
        
        self.addSubview(self.kkClipView)
        
        self.kkLayoutManager = .init(
            delegate: self,
            view: self.kkClipView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self.kkLayoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.kkLayoutManager.visibleFrame = .init(self.bounds)
        self.kkLayoutManager.updateIfNeeded()
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
    
    final class KKClipView : UIView {
        
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
            
            self.kkMaskLayer = .init()
            
            super.init(frame: frame)
            
            self.clipsToBounds = false
            
            self.layer.mask = self.kkMaskLayer
            self.layer.addSublayer(self.kkBorderLayer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(layout: IUILayout) {
        self.kkLayoutManager.layout = layout
        self.setNeedsLayout()
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
        self.kkClipView.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkLayoutManager.layout = nil
        self.kkDelegate = nil
    }
    
}

private extension KKMaskView {
    
    func _updatePath() {
        self.layer.shadowPath = CGPath.kk_roundRect(
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
    
    func setNeedUpdate(_ appearedLayout: IUILayout) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        defer {
            self.setNeedsLayout()
        }
        guard delegate.isDynamic(self) == true else {
            self.kkLayoutManager.setNeed(layout: true)
            return false
        }
        self.kkLayoutManager.setNeed(layout: true)
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: IUILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
