//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.External {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.External
        typealias Content = KKExternalView

        static var reuseIdentificator: String {
            return "UI.View.External"
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

final class KKExternalView : NSView {
    
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
    
    private unowned var _view: UI.View.External?
    
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

extension KKExternalView {
    
    func update(view: UI.View.External) {
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
