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

    var kkLayer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
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
            case .axial: self.kkLayer.type = .axial
            case .radial: self.kkLayer.type = .radial
            }
            self.kkLayer.colors = fill.points.map({ $0.color.cgColor })
            self.kkLayer.locations = fill.points.map({ NSNumber(value: $0.location) })
            self.kkLayer.startPoint = fill.start.cgPoint
            self.kkLayer.endPoint = fill.end.cgPoint
            self.kkLayer.isHidden = false
        } else {
            self.kkLayer.isHidden = true
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
