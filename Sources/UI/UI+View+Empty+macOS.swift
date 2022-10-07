//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Empty {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Empty
        typealias Content = KKEmptyView

        static var reuseIdentificator: String {
            return "UI.View.Empty"
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

final class KKEmptyView : NSView {
        
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private unowned var _view: UI.View.Empty?
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKEmptyView {
    
    func update(view: UI.View.Empty) {
        self._view = view
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
