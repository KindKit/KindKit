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
        var size: Size
        var views: [IUIView]

        @inline(__always)
        init(contentView: NativeView, delegate: IUILayoutDelegate) {
            self.contentView = contentView
            self.delegate = delegate
            self.size = .zero
            self.views = []
        }
        
        @inline(__always)
        func invalidate() {
            if let layout = self.layout {
                layout.invalidate()
            }
        }
        
        @inline(__always)
        mutating func layout(bounds: Rect) {
            if let layout = self.layout {
                self.size = layout.layout(bounds: bounds)
            } else {
                self.size = .zero
            }
        }
        
        @inline(__always)
        mutating func visible(bounds: Rect, inset: Inset = .zero) {
            if let layout = self.layout {
                let views = layout.views(
                    bounds: Rect(
                        x: bounds.origin.x - inset.left,
                        y: bounds.origin.y - inset.top,
                        width: bounds.size.width + inset.horizontal,
                        height: bounds.size.height + inset.vertical
                    )
                )
                let disappearing = self.views.filter({ view in
                    return views.contains(where: { view === $0 }) == false
                })
                if disappearing.count > 0 {
                    for view in disappearing {
                        self._disappear(view: view)
                    }
                }
                for (index, view) in views.enumerated() {
                    let isLoaded = view.isLoaded
                    let isAppeared = view.isAppeared
                    let isHidden = view.isHidden
                    if isHidden == false {
                        let frame = view.frame
                        let isVisible = bounds.isIntersects(frame)
                        if isLoaded == true || isVisible == true {
                            view.frame = frame
                            if view.native.superview !== self.contentView {
#if os(macOS)
                                let subviews = self.contentView.subviews
                                if subviews.isEmpty == true || index >= subviews.count {
                                    self.contentView.addSubview(view.native)
                                } else {
                                    self.contentView.addSubview(view.native, positioned: .below, relativeTo: subviews[index])
                                }
#elseif os(iOS)
                                self.contentView.insertSubview(view.native, at: index)
#endif
                            }
                        }
                        if isAppeared == false {
                            view.appear(to: layout)
                        }
                        if isVisible == true {
                            if view.isVisible == false {
                                view.visible()
                            } else {
                                view.visibility()
                            }
                        } else {
                            if view.isVisible == true {
                                view.invisible()
                            }
                        }
                    } else {
                        if isAppeared == false {
                            view.appear(to: layout)
                        }
                        if view.isVisible == true {
                            view.invisible()
                        }
                        if isLoaded == true {
                            view.native.removeFromSuperview()
                        }
                    }
                }
                self.views = views
            } else {
                self.clear()
            }
        }
        
        @inline(__always)
        mutating func clear() {
            for view in self.views {
                self._disappear(view: view)
            }
            self.views.removeAll()
        }
        
    }

}

private extension UI.Layout.Manager {
    
    @inline(__always)
    func _disappear(view: IUIView) {
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
