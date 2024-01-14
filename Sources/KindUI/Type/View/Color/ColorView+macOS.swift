//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension ColorView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ColorView
        typealias Content = KKColorView

        static var reuseIdentificator: String {
            return "ColorView"
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

final class KKColorView : NSView {
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKColorView {
    
    func update(view: ColorView) {
        self.update(frame: view.frame)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(color: Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
