//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension ColorView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ColorView
        typealias Content = KKColorView
        
        static func name(owner: Owner) -> String {
            return "ColorView"
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

final class KKColorView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKColorView {
    
    func kk_update(view: ColorView) {
        self.kk_update(frame: view.frame)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    final func kk_cleanup(view: ColorView) {
    }
    
}

extension KKColorView {
    
    func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
}

#endif
