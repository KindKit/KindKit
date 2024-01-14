//
//  KindKit
//

import KindMath

public protocol ILayoutDelegate : AnyObject {
    
    @discardableResult
    func setNeedUpdate(_ layout: ILayout) -> Bool
    
    func updateIfNeeded(_ layout: ILayout)
    
}

public protocol ILayout : AnyObject {
    
    var delegate: ILayoutDelegate? { set get }
    var appearedView: IView? { set get }
    
    func invalidate()
    
    func invalidate(_ view: IView)

    func layout(bounds: Rect) -> Size
    
    func size(available: Size) -> Size
    
    func views(bounds: Rect) -> [IView]
    
}

public extension ILayout {
    
    func invalidate() {
    }
    
    func invalidate(_ view: IView) {
    }
    
    @inlinable
    func setNeedUpdate(_ view: IView? = nil) {
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
        self.delegate?.setNeedUpdate(self)
        self.delegate?.updateIfNeeded(self)
    }
    
    @inlinable
    func layout(bounds: Rect, inset: Inset) -> Size {
        return self.layout(bounds: bounds.inset(inset)).inset(-inset)
    }
    
    @inlinable
    func visible(views: [IView], for bounds: Rect) -> [IView] {
        guard let firstIndex = views.firstIndex(where: { return bounds.isIntersects($0.frame) }) else {
            return []
        }
        var result: [IView] = [ views[firstIndex] ]
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
