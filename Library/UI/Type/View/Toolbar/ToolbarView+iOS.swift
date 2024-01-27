//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindGeometry

extension ToolbarView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ToolbarView
        typealias Content = KKToolbarView
        
        static func name(owner: Owner) -> String {
            return "ToolbarView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init()
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKToolbarView : UIToolbar {
    
    weak var kkDelegate: KKToolbarViewDelegate?
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.backgroundColor = .clear
        self.isTranslucent = true
        self.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKToolbarView {
    
    final func kk_update(view: ToolbarView) {
        self.kk_update(frame: view.frame)
        self.kk_update(items: view.items)
        self.kk_update(tintColor: view.tintColor)
        self.kkDelegate = view
    }
    
    final func kk_cleanup() {
        self.kkDelegate = nil
    }
    
}

extension KKToolbarView {
    
    final func kk_update(items: [any IToolbarItem]) {
        let items = items.map({ $0.handle })
        for item in items {
            item.target = self
            item.action = #selector(self._pressed(_:))
        }
        self.items = items
    }
    
    final func kk_update(tintColor: Color?) {
        self.tintColor = tintColor?.native
    }
    
}

private extension KKToolbarView {
    
    @objc
    func _pressed(_ sender: UIBarButtonItem) {
        self.kkDelegate?.kk_pressed(sender)
    }
    
}

#endif
