//
//  KindKit
//

#if os(macOS)

import AppKit

public typealias NativeView = NSView

public extension NSView {
    
    func isChild(of view: NSView, recursive: Bool) -> Bool {
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
        case .manual(let radius):
            layer.cornerRadius = CGFloat(radius)
        case .auto:
            let boundsSize = self.bounds.size
            layer.cornerRadius = CGFloat(ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2))
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
