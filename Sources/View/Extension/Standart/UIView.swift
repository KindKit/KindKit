//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore

extension UIView {
    
    func update(locked: Bool) {
        self.isUserInteractionEnabled = locked == false
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(tintColor: Color?) {
        self.tintColor = tintColor?.native
    }
    
    func update(cornerRadius: ViewCornerRadius) {
        let layer = self.layer
        switch cornerRadius {
        case .none: layer.cornerRadius = 0
        case .manual(let radius): layer.cornerRadius = CGFloat(radius)
        case .auto:
            let size = self.bounds.size
            if size.width > 0 && size.height > 0 {
                layer.cornerRadius = ceil(min(size.width - 1, size.height - 1)) / 2
            } else {
                layer.cornerRadius = 0
            }
        }
    }
    
    func update(border: ViewBorder) {
        let layer = self.layer
        switch border {
        case .none:
            layer.borderWidth = 0
            layer.borderColor = nil
        case .manual(let width, let color):
            layer.borderWidth = CGFloat(width)
            layer.borderColor = color.cgColor
        }
    }
    
    func update(shadow: ViewShadow?) {
        let layer = self.layer
        if let shadow = shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowOpacity = Float(shadow.opacity)
            layer.shadowRadius = CGFloat(shadow.radius)
            layer.shadowOffset = CGSize(
                width: CGFloat(shadow.offset.x),
                height: CGFloat(shadow.offset.y)
            )
            self.clipsToBounds = false
        } else {
            layer.shadowColor = nil
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
            layer.shadowOffset = .zero
            self.clipsToBounds = true
        }
    }
    
    func updateShadowPath() {
        let layer = self.layer
        if layer.shadowColor != nil {
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: layer.cornerRadius)
            layer.shadowPath = path.cgPath
        } else {
            layer.shadowPath = nil
        }
    }
    
    func update(alpha: Float) {
        self.alpha = CGFloat(alpha)
    }
    
}

#endif
