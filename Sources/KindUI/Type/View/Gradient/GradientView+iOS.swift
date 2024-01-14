//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension GradientView {
    
    struct Reusable : IReusable {
        
        typealias Owner = GradientView
        typealias Content = KKGradientView

        static var reuseIdentificator: String {
            return "GradientView"
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
    
    func update(view: GradientView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(fill: view.fill)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(fill: GradientView.Fill?) {
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
