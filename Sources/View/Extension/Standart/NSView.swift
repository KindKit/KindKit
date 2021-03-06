//
//  KindKitView
//

#if os(macOS)

import AppKit

public extension NSView {
    
    func update(color: Color?) {
        let layer = self.layer!
        if let color = color {
            layer.backgroundColor = color.native.cgColor
        } else {
            layer.backgroundColor = nil
        }
    }
    
    func update(border: ViewBorder) {
        let layer = self.layer!
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

    func update(shadow: ViewShadow?) {
        let layer = self.layer!
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
    
    func update(cornerRadius: ViewCornerRadius) {
        let layer = self.layer!
        switch cornerRadius {
        case .none:
            layer.cornerRadius = 0
        case .manual(let radius):
            layer.cornerRadius = CGFloat(radius)
        case .auto:
            let boundsSize = self.bounds.size
            layer.cornerRadius = CGFloat(ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2))
        }
    }

    func updateShadowPath() {
        let layer = self.layer!
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
