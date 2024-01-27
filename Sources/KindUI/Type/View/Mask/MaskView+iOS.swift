//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension MaskView {
    
    struct Reusable : IReusable {
        
        typealias Owner = MaskView
        typealias Content = KKMaskView
        
        static func name(owner: Owner) -> String {
            return "MaskView"
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

final class KKMaskView : UIView {
    
    var kkBorder: Border {
        set { self.kkClipView.kkBorder = newValue }
        get { self.kkClipView.kkBorder }
    }
    var kkCornerRadius: CornerRadius {
        set { self.kkClipView.kkCornerRadius = newValue }
        get { self.kkClipView.kkCornerRadius }
    }
    var kkShadow: Shadow? {
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
        
        var kkBorder: Border = .none {
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
        var kkCornerRadius: CornerRadius = .none {
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
    
    final func kk_update< LayoutType : ILayout >(view: MaskView< LayoutType >) {
        self.kk_update(frame: view.frame)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        view.holder = LayoutHolder(self.kkClipView)
    }
    
    final func kk_cleanup< LayoutType : ILayout >(view: MaskView< LayoutType >) {
        view.holder = nil
    }
    
}

extension KKMaskView {
    
    final func kk_update(border: Border) {
        self.kkBorder = border
    }
    
    final func kk_update(cornerRadius: CornerRadius) {
        self.kkCornerRadius = cornerRadius
    }
    
    final func kk_update(shadow: Shadow?) {
        self.kkShadow = shadow
    }
    
    final func kk_update(color: Color) {
        self.kkClipView.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
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

#endif
