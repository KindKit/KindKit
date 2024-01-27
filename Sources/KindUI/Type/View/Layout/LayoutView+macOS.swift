//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindLayout

extension LayoutView {
    
    struct Reusable : IReusable {
        
        typealias Owner = LayoutView
        typealias Content = KKLayoutView
        
        static func name(owner: Owner) -> String {
            return "LayoutView"
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

final class KKLayoutView : NSView {
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        let hitView = super.hitTest(point)
        if hitView === self {
            return nil
        }
        return hitView
    }
    
}

extension KKLayoutView {
    
    final func kk_update< LayoutType : ILayout >(view: LayoutView< LayoutType >) {
        self.kk_update(frame: view.frame)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kk_update(clipsToBounds: view.clipsToBounds)
        view.holder = LayoutHolder(self)
    }
    
    final func kk_cleanup< LayoutType : ILayout >(view: LayoutView< LayoutType >) {
        view.holder = nil
    }
    
}

extension KKLayoutView {
    
    final func kk_update(color: Color) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color.native.cgColor
    }
    
    final func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    final func kk_update(clipsToBounds: Bool) {
        self.clipsToBounds = clipsToBounds
    }
    
}

#endif
