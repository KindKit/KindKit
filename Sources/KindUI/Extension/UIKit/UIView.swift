//
//  KindKit
//

#if os(iOS)

import UIKit
import KindMath

public typealias NativeView = UIView

public extension UIView {
    
    final var kk_firstResponder: UIView? {
        if self.isFirstResponder == true {
            return self
        }
        for subview in self.subviews {
            if let firstResponder = subview.kk_firstResponder {
                return firstResponder
            }
        }
        return nil
    }
    
    @inlinable
    final func kk_update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    final func kk_snapshot() -> UIImage? {
        self.layoutIfNeeded()
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image(actions: { context in
            self.layer.render(in: context.cgContext)
        })
    }
    
    final func kk_snapshot(afterScreenUpdates: Bool) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image(actions: { context in
            self.drawHierarchy(
                in: CGRect(origin: .zero, size: context.currentImage.size),
                afterScreenUpdates: afterScreenUpdates
            )
        })
    }
    
    final func kk_child< View >(of type: View.Type, recursive: Bool) -> View? {
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
    
    final func kk_isChild(of view: UIView, recursive: Bool) -> Bool {
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
    
}

#endif
