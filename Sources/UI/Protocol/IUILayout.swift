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
    var view: IUIView? { set get }
    
    func setNeedUpdate()
    func updateIfNeeded()
    
    func invalidate()
    func invalidate(item: UI.Layout.Item)

    func layout(bounds: RectFloat) -> SizeFloat
    
    func size(available: SizeFloat) -> SizeFloat
    
    func items(bounds: RectFloat) -> [UI.Layout.Item]
    
}

public extension IUILayout {
    
    func invalidate() {
    }
    
    func invalidate(item: UI.Layout.Item) {
    }
    
    @inlinable
    func setNeedForceUpdate(item: UI.Layout.Item? = nil) {
        if let item = item {
            self.invalidate(item: item)
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
            if let view = self.view, let item = view.appearedItem {
                if let layout = view.appearedLayout {
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
    func update() {
        self.delegate?.setNeedUpdate(self)
        self.delegate?.updateIfNeeded(self)
    }
    
    @inlinable
    func visible(items: [UI.Layout.Item], for bounds: RectFloat) -> [UI.Layout.Item] {
        guard let firstIndex = items.firstIndex(where: { return bounds.isIntersects($0.frame) }) else { return [] }
        var result: [UI.Layout.Item] = [ items[firstIndex] ]
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
