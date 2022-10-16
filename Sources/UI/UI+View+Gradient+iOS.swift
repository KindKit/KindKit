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
    
    typealias View = IUIView & IUIViewCornerRadiusable & IUIViewShadowable
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: View?
    private var _layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKGradientView {
    
    func update(view: UI.View.Gradient) {
        self._view = view
        self.update(fill: view.fill)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
    }
    
    func update(fill: UI.View.Gradient.Fill) {
        switch fill.mode {
        case .axial: self._layer.type = .axial
        case .radial: self._layer.type = .radial
        }
        self._layer.colors = fill.points.map({ $0.color.cgColor })
        self._layer.locations = fill.points.map({ NSNumber(value: $0.location) })
        self._layer.startPoint = fill.start.cgPoint
        self._layer.endPoint = fill.end.cgPoint
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
