//
//  KindKit
//

#if os(macOS)

import AppKit
import KindDebug
import KindMath

public typealias NativeView = NSView

public extension NSView {
    
    @inlinable
    func kk_update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    final func kk_snapshot() -> NSImage? {
        self.layoutSubtreeIfNeeded()
        guard let rep = self.bitmapImageRepForCachingDisplay(in: self.bounds) else {
            return nil
        }
        self.cacheDisplay(in: self.bounds, to: rep)
        let image = NSImage()
        image.addRepresentation(rep)
        return image
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
    
    func kk_isChild(of view: NSView, recursive: Bool) -> Bool {
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

extension NSView : KindDebug.IEntity {
    
    public func debugInfo() -> Info {
        return .object(name: self.className, sequence: { items in
            items.append(.pair(string: "Frame", cast: self.frame))
            if self.subviews.isEmpty == false {
                items.append(.pair(
                    string: "Subviews",
                    cast: self.subviews
                ))
            }
        })
    }
    
}

#endif
