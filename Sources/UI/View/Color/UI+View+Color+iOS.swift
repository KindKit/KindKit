//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Color {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Color
        typealias Content = KKColorView

        static var reuseIdentificator: String {
            return "UI.View.Color"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKColorView : UIView {
}

extension KKColorView {
    
    func update(view: UI.View.Color) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
