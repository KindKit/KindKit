//
//  KindKit
//

#if os(macOS)

import AppKit

public typealias NativeView = NSView

public extension NSView {
    
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
    
    func isChild(of view: NSView, recursive: Bool) -> Bool {
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
    
    func update(color: UI.Color?) {
        guard let layer = self.layer else { return }
        if let color = color {
            layer.backgroundColor = color.native.cgColor
        } else {
            layer.backgroundColor = nil
        }
    }
    
    func update(border: UI.Border) {
        guard let layer = self.layer else { return }
        switch border {
        case .none:
            layer.borderWidth = 0
            layer.borderColor = nil
            break
        case .manual(let width, let color):
            layer.borderWidth = CGFloat(width)
            layer.borderColor = color.cgColor
            break
        }
    }

    func update(shadow: UI.Shadow?) {
        guard let layer = self.layer else { return }
        if let shadow = shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowOpacity = Float(shadow.opacity)
            layer.shadowRadius = CGFloat(shadow.radius)
            layer.shadowOffset = CGSize(
                width: CGFloat(shadow.offset.x),
                height: CGFloat(shadow.offset.y)
            )
            layer.masksToBounds = false
        } else {
            layer.shadowColor = nil
            layer.masksToBounds = false
        }
    }
    
    func update(cornerRadius: UI.CornerRadius) {
        guard let layer = self.layer else { return }
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

    func updateShadowPath() {
        guard let layer = self.layer else { return }
        if layer.shadowColor != nil {
            layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: layer.cornerRadius, cornerHeight: layer.cornerRadius, transform: nil)
        } else {
            layer.shadowPath = nil
        }
    }
    
    func update(alpha: Float) {
        self.alphaValue = CGFloat(alpha)
    }
    
}

#endif
