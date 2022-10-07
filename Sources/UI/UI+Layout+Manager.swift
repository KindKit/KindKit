//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

extension UI.Layout {

    struct Manager {
        
        unowned let contentView: NativeView
        unowned let delegate: IUILayoutDelegate
        var layout: IUILayout? {
            willSet {
                self.layout?.delegate = nil
                self.clear()
            }
            didSet {
                self.layout?.delegate = self.delegate
            }
        }
        var size: SizeFloat
        var items: [UI.Layout.Item]

        @inline(__always)
        init(contentView: NativeView, delegate: IUILayoutDelegate) {
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
                    return items.contains(item) == false
                })
                if disappearing.count > 0 {
                    for item in disappearing {
                        self._disappear(item: item)
                    }
                }
                var needForceUpdate = false
                for (index, item) in items.enumerated() {
                    let isLoaded = item.isLoaded
                    let isAppeared = item.isAppeared
                    let isHidden = item.isHidden
                    if isHidden == false {
                        let frame = item.frame
                        let isVisible = bounds.isIntersects(frame)
                        if isLoaded == true || isVisible == true {
                            item.view.native.frame = frame.cgRect
                            if isVisible == true && item.isNeedForceUpdate == true {
                                layout.invalidate(item: item)
                                item.resetNeedForceUpdate()
                                needForceUpdate = true
                            }
                            if item.view.native.superview !== self.contentView {
#if os(macOS)
                                self.contentView.addSubview(item.view.native, positioned: .above, relativeTo: self.contentView.subviews.last)
#elseif os(iOS)
                                self.contentView.insertSubview(item.view.native, at: index)
#endif
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
                    } else {
                        if isAppeared == false {
                            item.view.appear(to: layout)
                        }
                        if item.view.isVisible == true {
                            item.view.invisible()
                        }
                        if isLoaded == true {
                            item.view.native.removeFromSuperview()
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
                self._disappear(item: item)
            }
            self.items.removeAll()
        }
        
    }

}

private extension UI.Layout.Manager {
    
    @inline(__always)
    func _disappear(item: UI.Layout.Item) {
        let native: NativeView?
        if item.view.isLoaded == true {
            native = item.view.native
        } else {
            native = nil
        }
        if item.view.isVisible == true {
            item.view.invisible()
        }
        if item.view.isAppeared == true {
            item.view.disappear()
        }
        native?.removeFromSuperview()
    }
    
}
