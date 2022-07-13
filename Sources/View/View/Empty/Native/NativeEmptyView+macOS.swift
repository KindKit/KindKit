//
//  KindKitView
//

#if os(macOS)

import AppKit
import KindKitCore
import KindKitMath

extension EmptyView {
    
    struct Reusable : IReusable {
        
        typealias Owner = EmptyView
        typealias Content = NativeEmptyView

        static var reuseIdentificator: String {
            return "EmptyView"
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

final class NativeEmptyView : NSView {
    
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
    
    private unowned var _view: View?
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension NativeEmptyView {
    
    func update(view: EmptyView) {
        self._view = view
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
