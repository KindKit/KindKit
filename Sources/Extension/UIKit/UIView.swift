//
//  KindKit
//

#if os(iOS)

import UIKit

public typealias NativeView = UIView

public extension UIView {
    
    func child< View >(of type: View.Type, recursive: Bool) -> View? {
        for subview in self.subviews {
            if let view = subview as? View {
                return view
            } else if recursive == true {
                if let view = subview.child(of: type, recursive: recursive) {
                    return view
                }
            }
            
        }
        return nil
    }
    
    func isChild(of view: UIView, recursive: Bool) -> Bool {
        if self === view {
            return true
        }
        for subview in self.subviews {
            if subview === view {
                return true
            } else if recursive == true {
                if subview.isChild(of: view, recursive: recursive) == true {
                    return true
                }
            }
            
        }
        return false
    }
    
    func update(locked: Bool) {
        self.isUserInteractionEnabled = locked == false
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(tintColor: Color?) {
        self.tintColor = tintColor?.native
    }
    
    func update(cornerRadius: UI.CornerRadius) {
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
    
    func update(border: UI.Border) {
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
    
    func update(shadow: UI.Shadow?) {
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
            layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: layer.cornerRadius, cornerHeight: layer.cornerRadius, transform: nil)
        } else {
            layer.shadowPath = nil
        }
    }
    
    func update(alpha: Float) {
        self.alpha = CGFloat(alpha)
    }
    
}

#endif
