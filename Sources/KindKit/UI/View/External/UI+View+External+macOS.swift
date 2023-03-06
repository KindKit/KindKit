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
    
    var content: NSView? {
        willSet {
            self.content?.removeFromSuperview()
        }
        didSet {
            guard let content = self.content else { return }
            content.frame = self.bounds
            self.addSubview(content)
        }
    }
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if let hitView = super.hitTest(point) {
            if hitView === self {
                return nil
            }
        }
        return nil
    }
    
    override func layout() {
        super.layout()
        
        if let content = self.content {
            content.frame = self.bounds
        }
    }
    
}

extension KKExternalView {
    
    func update(view: UI.View.External) {
        self.update(frame: view.frame)
        self.update(content: view.content)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(content: NSView?) {
        self.content = content
    }
    
    func cleanup() {
        self.content = nil
    }
    
}

#endif
