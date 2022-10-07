//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Blur {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Blur
        typealias Content = KKBlurView

        static var reuseIdentificator: String {
            return "UI.View.Blur"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(style: owner.style)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}
  
final class KKBlurView : UIVisualEffectView {
        
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { super.frame }
    }
    
    private unowned var _view: UI.View.Blur?
    private var _style: UIBlurEffect.Style {
        didSet {
            guard self._style != oldValue else { return }
            self.effect = UIBlurEffect(style: self._style)
        }
    }
    
    init(style: UIBlurEffect.Style) {
        self._style = style
        
        super.init(effect: UIBlurEffect(style: self._style))
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKBlurView {
    
    func update(view: UI.View.Blur) {
        self._view = view
        self.update(style: view.style)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
    }
    
    func update(style: UIBlurEffect.Style) {
        self._style = style
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
