//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Spinner {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Spinner
        typealias Content = KKSpinnerView

        static var reuseIdentificator: String {
            return "UI.View.Spinner"
        }
        
        static func createReuse(owner: Owner) -> Content {
            if #available(iOS 13.0, *) {
                return Content(style: .large)
            }
            return Content(style: .whiteLarge)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKSpinnerView : UIActivityIndicatorView {
    
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
    
    private unowned var _view: UI.View.Spinner?
    
    override init(style: Style) {
        super.init(style: style)

        self.isUserInteractionEnabled = false
        self.hidesWhenStopped = true
        self.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKSpinnerView {
    
    func update(view: UI.View.Spinner) {
        self._view = view
        self.update(activityColor: view.activityColor)
        self.update(scaleFactor: view.scaleFactor)
        self.update(isAnimating: view.isAnimating)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(activityColor: Color?) {
        self.color = activityColor?.native
    }
    
    func update(scaleFactor: Float) {
        self.transform = CGAffineTransform(scaleX: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
    }
    
    func update(isAnimating: Bool) {
        if isAnimating == true {
            self.startAnimating()
        } else {
            self.stopAnimating()
        }
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
