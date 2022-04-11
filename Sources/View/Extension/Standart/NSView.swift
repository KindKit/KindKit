//
//  KindKitView
//

#if os(OSX)

import AppKit

public extension NSView {
    
    func set(border: ViewBorder) {
        switch border {
        case .none:
            self.layer!.borderWidth = 0
            self.layer!.borderColor = nil
            break
        case .manual(let width, let color):
            self.layer!.borderWidth = CGFloat(width)
            self.layer!.borderColor = color.cgColor
            break
        }
    }

    func set(shadow: ViewShadow?) {
        if let shadow = shadow {
            self.layer!.shadowColor = shadow.color.cgColor
            self.layer!.shadowOpacity = Float(shadow.opacity)
            self.layer!.shadowRadius = CGFloat(shadow.radius)
            self.layer!.shadowOffset = CGSize(
                width: CGFloat(shadow.offset.x),
                height: CGFloat(shadow.offset.y)
            )
            self.layer!.masksToBounds = false
        } else {
            self.layer!.shadowColor = nil
            self.layer!.masksToBounds = false
        }
    }
    
    func update(cornerRadius: ViewCornerRadius) {
        switch cornerRadius {
        case .none:
            self.layer!.cornerRadius = 0
        case .manual(let radius):
            self.layer!.cornerRadius = CGFloat(radius)
        case .auto:
            let boundsSize = self.bounds.size
            self.layer!.cornerRadius = CGFloat(ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2))
        }
    }

    func updateShadowPath() {
        #warning("Need impl")
    }
    
}

#endif
