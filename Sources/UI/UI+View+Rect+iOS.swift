//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Rect {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Rect
        typealias Content = KKRectView

        static var reuseIdentificator: String {
            return "UI.View.Rect"
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
                self._shareLayer.lineWidth = self.kkBorderWidth
            })
            self.setNeedsLayout()
        }
    }
    var kkBorderColor: CGColor? {
        didSet {
            guard self.kkBorderColor != oldValue else { return }
            CATransaction.kk_withoutActions({
                self._shareLayer.strokeColor = self.kkBorderColor
            })
            self.setNeedsLayout()
        }
    }
    var kkCornerRadius: UI.CornerRadius = .none {
        didSet {
            guard self.kkCornerRadius != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    
    private var _shareLayer: CAShapeLayer
        
    override init(frame: CGRect) {
        self._shareLayer = CAShapeLayer()
        self._shareLayer.contentsScale = UIScreen.main.scale
        
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        
        self.layer.addSublayer(self._shareLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.kk_withoutActions({
            self._shareLayer.path = self._path(bounds: self.bounds).cgPath
        })
    }
    
}

private extension KKRectView {
    
    func _path(bounds: CGRect) -> UIBezierPath {
        let pathRect: CGRect
        if self.kkBorderColor != nil {
            let borderWidth = (self.kkBorderWidth / 2)
            pathRect = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        } else {
            pathRect = bounds
        }
        let pathRadius: CGFloat
        let pathCorners: UIRectCorner
        switch self.kkCornerRadius {
        case .none:
            pathRadius = 0
            pathCorners = []
        case .manual(let radius, let edges):
            pathRadius = CGFloat(radius)
            pathCorners = edges.uiRectCorner
        case .auto(let percent, let edges):
            let width = pathRect.width
            let height = pathRect.height
            if width > 0 && height > 0 {
                pathRadius = ceil(min(width - 1, height - 1)) * CGFloat(percent.value)
                pathCorners = edges.uiRectCorner
            } else {
                pathRadius = 0
                pathCorners = []
            }
        }
        return UIBezierPath(
            roundedRect: pathRect,
            byRoundingCorners: pathCorners,
            cornerRadii: .init(width: pathRadius, height: pathRadius)
        )
    }
    
}

extension KKRectView {
    
    func update(view: UI.View.Rect) {
        self.update(fill: view.fill)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(fill: UI.Color?) {
        CATransaction.kk_withoutActions({
            self._shareLayer.fillColor = fill?.cgColor
        })
    }
    
    func update(border: UI.Border) {
        switch border {
        case .none:
            self.kkBorderWidth = 0
            self.kkBorderColor = nil
        case .manual(let width, let color):
            self.kkBorderWidth = CGFloat(width)
            self.kkBorderColor = color.cgColor
        }
    }
    
    func update(cornerRadius: UI.CornerRadius) {
        self.kkCornerRadius = cornerRadius
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Float) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
