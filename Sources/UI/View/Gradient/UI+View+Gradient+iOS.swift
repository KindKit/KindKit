//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Gradient {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Gradient
        typealias Content = KKGradientView

        static var reuseIdentificator: String {
            return "UI.View.Gradient"
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

final class KKGradientView : UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var _layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKGradientView {
    
    func update(view: UI.View.Gradient) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(fill: view.fill)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(fill: UI.View.Gradient.Fill?) {
        if let fill = fill {
            switch fill.mode {
            case .axial: self._layer.type = .axial
            case .radial: self._layer.type = .radial
            }
            self._layer.colors = fill.points.map({ $0.color.cgColor })
            self._layer.locations = fill.points.map({ NSNumber(value: $0.location) })
            self._layer.startPoint = fill.start.cgPoint
            self._layer.endPoint = fill.end.cgPoint
            self._layer.isHidden = false
        } else {
            self._layer.isHidden = true
        }
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
