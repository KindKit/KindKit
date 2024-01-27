//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension PlatformView {
    
    struct Reusable : IReusable {
        
        typealias Owner = PlatformView
        typealias Content = KKPlatformView
        
        static func name(owner: Owner) -> String {
            return "PlatformView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKPlatformView : NSView {
    
    var kkContent: NSView? {
        willSet {
            self.kkContent?.removeFromSuperview()
        }
        didSet {
            guard let content = self.kkContent else { return }
            content.frame = self.bounds
            self.addSubview(content)
        }
    }
    
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
        if let hitView = super.hitTest(point) {
            if hitView === self {
                return nil
            }
        }
        return nil
    }
    
    override func layout() {
        super.layout()
        
        if let content = self.kkContent {
            content.frame = self.bounds
        }
    }
    
}

extension KKPlatformView {
    
    func kk_update(view: PlatformView) {
        self.kk_update(frame: view.frame)
        self.kk_update(content: view.content)
    }
    
    func kk_cleanup(view: PlatformView) {
        self.kkContent = nil
    }
    
}

extension KKPlatformView {
    
    func kk_update(content: NSView?) {
        self.kkContent = content
    }
    
}

extension KKPlatformView {
    
    func kk_sizeOf(_ available: CGSize) -> CGSize {
        guard let content = self.kkContent else { return .zero }
        let fittingSize = content.fittingSize
        return .init(
            width: min(available.width, fittingSize.width),
            height: min(available.height, fittingSize.height)
        )
    }
    
}

#endif
