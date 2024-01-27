//
//  KindKit
//

#if os(iOS)

import UIKit
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

final class KKLayoutView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
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
        view.holder = LayoutHolder(self)
    }
    
    final func kk_cleanup< LayoutType : ILayout >(view: LayoutView< LayoutType >) {
        view.holder = nil
    }
    
}

extension KKLayoutView {
    
    final func kk_update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
}

#endif
