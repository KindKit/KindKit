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
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.update(cornerRadius: view.cornerRadius)
                self.updateShadowPath()
            }
        }
        get { return super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    var content: NSView? {
        willSet {
            self.content?.removeFromSuperview()
        }
        didSet {
            guard let content = self.content else { return }
            self.addSubview(content)
        }
    }
    
    private unowned var _view: UI.View.External?
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    override func layout() {
        super.layout()
        
        if let content = self.content {
            let bounds = self.bounds
            let contentBounds = content.bounds
            content.frame = CGRect(
                x: (bounds.origin.x + (bounds.size.width / 2)) - (contentBounds.size.width / 2),
                y: (bounds.origin.y + (bounds.size.height / 2)) - (contentBounds.size.height / 2),
                width: contentBounds.size.width,
                height: contentBounds.size.height
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
    
    func update(content: NSView) {
        self.content = content
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
