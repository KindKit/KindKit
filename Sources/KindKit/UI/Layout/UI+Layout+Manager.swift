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

    final class Manager {
        
        unowned let delegate: IUILayoutDelegate
        unowned let view: NativeView
        var layout: IUILayout? {
            willSet {
                guard let layout = self.layout else { return }
                layout.delegate = nil
                self.clear()
            }
            didSet {
                guard let layout = self.layout else { return }
                layout.delegate = self.delegate
                self._needLayout = true
                self._needVisibility = true
            }
        }
        var visibleFrame: Rect = .zero {
            didSet {
                guard self.visibleFrame != oldValue else { return }
                if self.visibleFrame.size != oldValue.size {
                    self._needLayout = true
                    self._needVisibility = true
                } else {
                    self._needVisibility = true
                }
            }
        }
        var contentInsets: Inset = .zero {
            didSet {
                guard self.contentInsets != oldValue else { return }
                self._needLayout = true
                self._needVisibility = true
            }
        }
        var preloadInsets: Inset = .zero {
            didSet {
                guard self.preloadInsets != oldValue else { return }
                self.setNeed(visibility: true)
            }
        }
        private(set) var size: Size = .zero
        private(set) var views: [IUIView] = []
        
        private var _needLayout = true
        private var _needVisibility = true

        init(
            delegate: IUILayoutDelegate,
            view: NativeView
        ) {
            self.delegate = delegate
            self.view = view
        }
        
        func invalidate() {
            if let layout = self.layout {
                layout.invalidate()
            }
            self._needLayout = true
            self._needVisibility = true
        }
        
        func setNeed(layout: Bool, visibility: Bool) {
            if layout == true {
                self._needLayout = true
                self._needVisibility = true
            } else if visibility == true {
                self._needVisibility = true
            }
        }
        
        func updateIfNeeded() {
            guard let layout = self.layout else {
                self.size = .zero
                self.clear()
                return
            }
            if self._needLayout == true {
                self._needLayout = false
                self.size = layout.layout(bounds: .init(
                    origin: .zero,
                    size: self.visibleFrame.size
                ))
            }
            if self._needVisibility == true {
                self._needVisibility = false
                let views = layout.views(
                    bounds: self.visibleFrame.inset(-self.preloadInsets)
                )
                let disappearing = self.views.filter({ view in
                    return views.contains(where: { view === $0 }) == false
                })
                if disappearing.count > 0 {
                    for view in disappearing {
                        self._disappear(view: view)
                    }
                }
                var index: Int = 0
                for view in views {
                    let isLoaded = view.isLoaded
                    let isAppeared = view.isAppeared
                    let isHidden = view.isHidden
                    if isHidden == false {
                        let frame = view.frame
                        let isVisible = self.visibleFrame.isIntersects(frame)
                        if isLoaded == true || isVisible == true {
                            view.frame = frame
                            if view.native.superview !== self.view {
#if os(macOS)
                                let subviews = self.view.subviews
                                if subviews.isEmpty == true || index >= subviews.count {
                                    self.view.addSubview(view.native)
                                } else {
                                    self.view.addSubview(view.native, positioned: .below, relativeTo: subviews[index])
                                }
#elseif os(iOS)
                                self.view.insertSubview(view.native, at: index)
#endif
                            }
                        }
                        if isAppeared == false {
                            view.appear(to: layout)
                        }
                        if isVisible != view.isVisible {
                            switch isVisible {
                            case false: view.invisible()
                            case true: view.visible()
                            }
                        }
                        index += 1
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
            }
        }
        
        func clear() {
            for view in self.views {
                self._disappear(view: view)
            }
            self.views.removeAll()
            self.invalidate()
        }
        
    }

}

extension UI.Layout.Manager {
    
    @inline(__always)
    func setNeed(layout: Bool) {
        self.setNeed(layout: layout, visibility: false)
    }
    
    @inline(__always)
    func setNeed(visibility: Bool) {
        self.setNeed(layout: false, visibility: visibility)
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
        native?.removeFromSuperview()
        if view.isVisible == true {
            view.invisible()
        }
        if view.isAppeared == true {
            view.disappear()
        }
    }
    
}
