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
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: UI.View.Blur?
    private var _style: UIBlurEffect.Style {
        didSet(oldValue) {
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
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(style: UIBlurEffect.Style) {
        self._style = style
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
