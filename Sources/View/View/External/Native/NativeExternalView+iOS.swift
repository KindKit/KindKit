//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension ExternalView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ExternalView
        typealias Content = NativeExternalView

        static var reuseIdentificator: String {
            return "ExternalView"
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

final class NativeExternalView : UIView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
            }
        }
        get { return super.frame }
    }
    var external: UIView? {
        willSet {
            self.external?.removeFromSuperview()
        }
        didSet {
            guard let external = self.external else { return }
            self.addSubview(external)
        }
    }
    
    private unowned var _view: View?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let external = self.external {
            let bounds = self.bounds
            let externalBounds = external.bounds
            external.frame = CGRect(
                x: (bounds.origin.x + (bounds.size.width / 2)) - (externalBounds.size.width / 2),
                y: (bounds.origin.y + (bounds.size.height / 2)) - (externalBounds.size.height / 2),
                width: externalBounds.size.width,
                height: externalBounds.size.height
            )
        }
    }
    
}

extension NativeExternalView {
    
    func update(view: ExternalView) {
        self._view = view
        self.update(external: view.external)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(external: UIView) {
        self.external = external
    }
    
    func cleanup() {
        self.external = nil
        self._view = nil
    }
    
}

#endif
