//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ILayoutDelegate : AnyObject {
    
    @discardableResult
    func setNeedUpdate(_ layout: ILayout) -> Bool
    
    func updateIfNeeded(_ layout: ILayout)
    
}

public protocol ILayout : AnyObject {
    
    var delegate: ILayoutDelegate? { set get }
    var view: IView? { set get }
    
    func setNeedUpdate()
    func updateIfNeeded()
    
    func invalidate(item: LayoutItem)

    func layout(bounds: RectFloat) -> SizeFloat
    
    func size(available: SizeFloat) -> SizeFloat
    
    func items(bounds: RectFloat) -> [LayoutItem]
    
}

public extension ILayout {
    
    @inlinable
    func setNeedForceUpdate(item: LayoutItem? = nil) {
        if let item = item {
            self.invalidate(item: item)
        }
        let forceParent: Bool
        if let delegate = self.delegate {
            forceParent = delegate.setNeedUpdate(self)
        } else {
            forceParent = true
        }
        if forceParent == true {
            if let view = self.view, let item = view.item {
                if let layout = view.layout {
                    layout.setNeedForceUpdate(item: item)
                } else {
                    item.setNeedForceUpdate()
                }
            }
        }
    }
    
    @inlinable
    func setNeedUpdate() {
        self.delegate?.setNeedUpdate(self)
    }
    
    @inlinable
    func updateIfNeeded() {
        self.delegate?.updateIfNeeded(self)
    }
    
    @inlinable
    func invalidate(item: LayoutItem) {
    }
    
    @inlinable
    func visible(items: [LayoutItem], for bounds: RectFloat) -> [LayoutItem] {
        guard let firstIndex = items.firstIndex(where: { return bounds.isIntersects($0.frame) }) else { return [] }
        var result: [LayoutItem] = [ items[firstIndex] ]
        let start = min(firstIndex + 1, items.count)
        let end = items.count
        for index in start ..< end {
            let item = items[index]
            if bounds.isIntersects(item.frame) == true {
                result.append(item)
            } else {
                break
            }
        }
        return result
    }
    
}
