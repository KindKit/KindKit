//
//  KindKit
//

#if os(iOS)

import UIKit

public typealias NativeView = UIView

public extension UIView {
    
    var kk_firstResponder: UIView? {
        if self.isFirstResponder == true {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.kk_firstResponder {
                return firstResponder
            }
        }
        return nil
    }
    
}

public extension UIView {
    
    func kk_snapshot(afterScreenUpdates: Bool = true) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image(actions: {
            self.drawHierarchy(
                in: CGRect(origin: .zero, size: $0.currentImage.size),
                afterScreenUpdates: afterScreenUpdates
            )
        })
    }
    
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
    
}

#endif
