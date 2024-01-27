//
//  KindKit
//

#if os(iOS)

import UIKit

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

final class KKEmptyView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
