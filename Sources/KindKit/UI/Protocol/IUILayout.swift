//
//  KindKit
//

import Foundation

public protocol IUILayoutDelegate : AnyObject {
    
    @discardableResult
    func setNeedUpdate(_ layout: IUILayout) -> Bool
    
    func updateIfNeeded(_ layout: IUILayout)
    
}

public protocol IUILayout : AnyObject {
    
    var delegate: IUILayoutDelegate? { set get }
    var appearedView: IUIView? { set get }
    
    func invalidate()
    func invalidate(_ view: IUIView)

    func layout(bounds: Rect) -> Size
    
    func size(available: Size) -> Size
    
    func views(bounds: Rect) -> [IUIView]
    
}

public extension IUILayout {
    
    func invalidate() {
    }
    
    func invalidate(_ view: IUIView) {
    }
    
    @inlinable
    func setNeedUpdate(_ view: IUIView? = nil) {
        if let view = view {
            self.invalidate(view)
        }
        let forceParent: Bool
        if let delegate = self.delegate {
            if delegate.setNeedUpdate(self) == true {
                self.invalidate()
                forceParent = true
            } else {
                forceParent = false
            }
        } else {
            forceParent = true
        }
        if forceParent == true {
            if let view = self.appearedView {
                view.appearedLayout?.setNeedUpdate(view)
            }
        }
    }
    
    @inlinable
    func updateIfNeeded() {
        self.delegate?.updateIfNeeded(self)
    }
    
    @inlinable
    func update() {
        self.setNeedUpdate()
        self.delegate?.updateIfNeeded(self)
    }
    
    @inlinable
    func layout(bounds: Rect, inset: Inset) -> Size {
        return self.layout(bounds: bounds.inset(inset)).inset(-inset)
    }
    
    @inlinable
    func visible(views: [IUIView], for bounds: Rect) -> [IUIView] {
        guard let firstIndex = views.firstIndex(where: { return bounds.isIntersects($0.frame) }) else {
            return []
        }
        var result: [IUIView] = [ views[firstIndex] ]
        let start = min(firstIndex + 1, views.count)
        let end = views.count
        for index in start ..< end {
            let view = views[index]
            if bounds.isIntersects(view.frame) == true {
                result.append(view)
            } else {
                break
            }
        }
        return result
    }
    
}
