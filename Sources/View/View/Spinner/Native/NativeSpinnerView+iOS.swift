//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension SpinnerView {
    
    struct Reusable : IReusable {
        
        typealias Owner = SpinnerView
        typealias Content = NativeSpinnerView

        static var reuseIdentificator: String {
            return "SpinnerView"
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

final class NativeSpinnerView : UIActivityIndicatorView {
    
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
    
    private unowned var _view: SpinnerView?
    
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

extension NativeSpinnerView {
    
    func update(view: SpinnerView) {
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
    
    func update(activityColor: Color) {
        self.color = activityColor.native
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
