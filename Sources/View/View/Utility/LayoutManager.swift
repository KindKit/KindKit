//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
import KindKitCore
import KindKitMath

struct LayoutManager {
    
    unowned let contentView: NativeView
    unowned let delegate: ILayoutDelegate
    var layout: ILayout? {
        willSet(newValue) {
            self.layout?.delegate = nil
            self.clear()
        }
        didSet(oldValue) {
            self.layout?.delegate = self.delegate
        }
    }
    var size: SizeFloat
    var items: [LayoutItem]

    @inline(__always)
    init(contentView: NativeView, delegate: ILayoutDelegate) {
        self.contentView = contentView
        self.delegate = delegate
        self.size = .zero
        self.items = []
    }
    
    @inline(__always)
    mutating func layout(bounds: RectFloat) {
        if let layout = self.layout {
            self.size = layout.layout(bounds: bounds)
        } else {
            self.size = .zero
        }
    }
    
    @inline(__always)
    mutating func visible(bounds: RectFloat, inset: InsetFloat = .zero) {
        if let layout = self.layout {
            let items = layout.items(
                bounds: RectFloat(
                    x: bounds.origin.x - inset.left,
                    y: bounds.origin.y - inset.top,
                    width: bounds.size.width + inset.horizontal,
                    height: bounds.size.height + inset.vertical
                )
            )
            let disappearing = self.items.filter({ item in
                return items.contains(where: { return item === $0 }) == false
            })
            if disappearing.count > 0 {
                for item in disappearing {
                    self._disappear(view: item.view)
                }
            }
            var needForceUpdate = false
            for (index, item) in items.enumerated() {
                let frame = item.frame
                let isLoaded = item.view.isLoaded
                let isAppeared = item.view.isAppeared
                let isVisible = bounds.isIntersects(frame)
                if isLoaded == true || isVisible == true {
                    item.view.native.frame = frame.cgRect
                    if isVisible == true && item.isNeedForceUpdate == true {
                        layout.invalidate(item: item)
                        item.resetNeedForceUpdate()
                        needForceUpdate = true
                    }
                    if item.view.native.superview !== self.contentView {
                        self.contentView.insertSubview(item.view.native, at: index)
                    }
                }
                if isAppeared == false {
                    item.view.appear(to: layout)
                }
                if isVisible == true {
                    if item.view.isVisible == false {
                        item.view.visible()
                    } else {
                        item.view.visibility()
                    }
                } else {
                    if item.view.isVisible == true {
                        item.view.invisible()
                    }
                }
            }
            self.items = items
            if needForceUpdate == true {
                layout.setNeedForceUpdate()
            }
        } else {
            self.clear()
        }
    }
    
    @inline(__always)
    mutating func clear() {
        for item in self.items {
            self._disappear(view: item.view)
        }
        self.items.removeAll()
    }
    
}

private extension LayoutManager {
    
    @inline(__always)
    func _disappear(view: IView) {
        let native: NativeView?
        if view.isLoaded == true {
            native = view.native
        } else {
            native = nil
        }
        if view.isVisible == true {
            view.invisible()
        }
        if view.isAppeared == true {
            view.disappear()
        }
        native?.removeFromSuperview()
    }
    
}
