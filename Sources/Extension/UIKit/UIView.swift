//
//  KindKit
//

#if os(iOS)

import UIKit

public typealias NativeView = UIView

public extension UIView {
    
    func kk_child< View >(of type: View.Type, recursive: Bool) -> View? {
        for subview in self.subviews {
            if let view = subview as? View {
                return view
            } else if recursive == true {
                if let view = subview.kk_child(of: type, recursive: recursive) {
                    return view
                }
            }
            
        }
        return nil
    }
    
    func kk_isChild(of view: UIView, recursive: Bool) -> Bool {
        if self === view {
            return true
        }
        for subview in self.subviews {
            if subview === view {
                return true
            } else if recursive == true {
                if subview.kk_isChild(of: view, recursive: recursive) == true {
                    return true
                }
            }
            
        }
        return false
    }
    
    func kk_update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func kk_update(cornerRadius: UI.CornerRadius) {
        let layer = self.layer
        switch cornerRadius {
        case .none:
            layer.cornerRadius = 0
            layer.maskedCorners = [ .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner ]
        case .auto(let percent, let edges):
            let size = self.bounds.size
            if size.width > 0 && size.height > 0 {
                layer.cornerRadius = ceil(min(size.width - 1, size.height - 1)) * CGFloat(percent.value)
            } else {
                layer.cornerRadius = 0
            }
            layer.maskedCorners = edges.caCornerMask
        case .manual(let radius, let edges):
            layer.cornerRadius = CGFloat(radius)
            layer.maskedCorners = edges.caCornerMask
        }
    }
    
    func kk_update(border: UI.Border) {
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
    
    func kk_update(shadow: UI.Shadow?) {
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
    
    func kk_updateShadowPath() {
        let layer = self.layer
        if layer.shadowColor != nil {
            layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: layer.cornerRadius, cornerHeight: layer.cornerRadius, transform: nil)
        } else {
            layer.shadowPath = nil
        }
    }
    
    func kk_update(alpha: Float) {
        self.alpha = CGFloat(alpha)
    }
    
}

#endif
