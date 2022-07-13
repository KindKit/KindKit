//
//  KindKitView
//

#if os(macOS)

import AppKit
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

final class NativeExternalView : NSView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: NativeControlViewDelegate?
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
    override var isFlipped: Bool {
        return true
    }
    var external: NSView? {
        willSet {
            self.external?.removeFromSuperview()
        }
        didSet {
            guard let external = self.external else { return }
            self.addSubview(external)
        }
    }
    
    private unowned var _view: View?
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    override func layout() {
        super.layout()
        
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
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(external: NSView) {
        self.external = external
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
