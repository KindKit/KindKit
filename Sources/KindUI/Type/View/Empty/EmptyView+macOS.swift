//
//  KindKit
//

#if os(macOS)

import AppKit

extension EmptyView {
    
    struct Reusable : IReusable {
        
        typealias Owner = EmptyView
        typealias Content = KKEmptyView
        
        static func name(owner: Owner) -> String {
            return "EmptyView"
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

final class KKEmptyView : NSView {
    
    override var isFlipped: Bool {
        return true
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKEmptyView {
    
    final func kk_update(view: EmptyView) {
        self.kk_update(frame: view.frame)
    }
    
    final func kk_cleanup(view: EmptyView) {
    }
    
}

#endif
