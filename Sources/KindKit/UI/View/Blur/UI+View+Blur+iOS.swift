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
    
    var kkStyle: UIBlurEffect.Style {
        didSet {
            guard self.kkStyle != oldValue else { return }
            self.effect = UIBlurEffect(style: self.kkStyle)
        }
    }
    
    init(style: UIBlurEffect.Style) {
        self.kkStyle = style
        
        super.init(effect: UIBlurEffect(style: self.kkStyle))
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKBlurView {
    
    func update(view: UI.View.Blur) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(style: view.style)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(style: UIBlurEffect.Style) {
        self.kkStyle = style
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
