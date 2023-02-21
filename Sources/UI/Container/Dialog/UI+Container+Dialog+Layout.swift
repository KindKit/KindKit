//
//  KindKit
//

import Foundation

extension UI.Container.Dialog {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var inset: Inset {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var hook: IUIView {
            didSet {
                guard self.hook !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var dialogItem: UI.Container.DialogItem? {
            didSet {
                guard self.dialogItem !== oldValue else { return }
                self._dialogSize = nil
                self.setNeedUpdate()
            }
        }
        var dialogSize: Size? {
            self.updateIfNeeded()
            return self._dialogSize
        }
        
        private var _lastBoundsSize: Size?
        private var _dialogSize: Size?
        
        init(
            inset: Inset,
            hook: IUIView,
            content: IUIView?,
            state: State
        ) {
            self.inset = inset
            self.hook = hook
            self.content = content
            self.state = state
        }
        
        func invalidate(_ view: IUIView) {
            if self.dialogItem?.view === view {
                self._dialogSize = nil
            }
        }
        
        func layout(bounds: Rect) -> Size {
            if let lastBoundsSize = self._lastBoundsSize {
                if lastBoundsSize != bounds.size {
                    self._dialogSize = nil
                    self._lastBoundsSize = bounds.size
                }
            } else {
                self._dialogSize = nil
                self._lastBoundsSize = bounds.size
            }
            self.hook.frame = bounds
            if let content = self.content {
                content.frame = bounds
            }
            if let dialog = self.dialogItem {
                if let background = dialog.background {
                    background.frame = bounds
                }
                let availableBounds = bounds.inset(dialog.container.dialogInset)
                let size: Size
                if let dialogSize = self._dialogSize {
                    size = dialogSize
                } else {
                    size = self._size(bounds: availableBounds, dialog: dialog)
                    self._dialogSize = size
                }
                switch self.state {
                case .idle:
                    dialog.view.frame = self._idleRect(bounds: availableBounds, dialog: dialog, size: size)
                case .present(let progress):
                    let beginRect = self._presentRect(bounds: availableBounds, dialog: dialog, size: size)
                    let endRect = self._idleRect(bounds: availableBounds, dialog: dialog, size: size)
                    dialog.view.frame = beginRect.lerp(endRect, progress: progress)
                    if let view = dialog.view as? IUIViewAlphable {
                        view.alpha = progress.value
                    }
                    if let background = dialog.background {
                        background.alpha = progress.value
                    }
                case .dismiss(let progress):
                    let beginRect = self._idleRect(bounds: availableBounds, dialog: dialog, size: size)
                    let endRect = self._dismissRect(bounds: availableBounds, dialog: dialog, size: size)
                    dialog.view.frame = beginRect.lerp(endRect, progress: progress)
                    if let view = dialog.view as? IUIViewAlphable {
                        view.alpha = progress.invert.value
                    }
                    if let background = dialog.background {
                        background.alpha = progress.invert.value
                    }
                }
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IUIView] {
            var views: [IUIView] = []
            if let content = self.content {
                views.append(content)
            }
            if let dialogItem = self.dialogItem {
                views.append(self.hook)
                if let background = dialogItem.background {
                    views.append(background)
                }
                views.append(dialogItem.view)
            }
            return views
        }
        
    }
    
}

extension UI.Container.Dialog.Layout {
    
    @inline(__always)
    func _size(bounds: Rect, dialog: UI.Container.DialogItem) -> Size {
        let width, height: Double
        if dialog.container.dialogSize.width == .fit && dialog.container.dialogSize.height == .fit {
            let size = dialog.view.size(available: bounds.size)
            width = min(size.width, bounds.width)
            height = min(size.height, bounds.height)
        } else if dialog.container.dialogSize.width == .fit {
            switch dialog.container.dialogSize.height {
            case .fill(let before, let after): height = bounds.size.height - (before + after)
            case .fixed(let value): height = value
            case .fit: height = bounds.height
            }
            let size = dialog.view.size(available: Size(width: bounds.size.width, height: height))
            width = min(size.width, bounds.width)
        } else if dialog.container.dialogSize.height == .fit {
            switch dialog.container.dialogSize.width {
            case .fill(let before, let after): width = bounds.size.width - (before + after)
            case .fixed(let value): width = value
            case .fit: width = bounds.width
            }
            let size = dialog.view.size(available: Size(width: width, height: bounds.size.height))
            height = min(size.height, bounds.height)
        } else {
            switch dialog.container.dialogSize.width {
            case .fill(let before, let after): width = bounds.size.width - (before + after)
            case .fixed(let value): width = value
            case .fit: width = bounds.width
            }
            switch dialog.container.dialogSize.height {
            case .fill(let before, let after): height = bounds.size.height - (before + after)
            case .fixed(let value): height = value
            case .fit: height = bounds.height
            }
        }
        return Size(width: width, height: height)
    }
    
    @inline(__always)
    func _presentRect(bounds: Rect, dialog: UI.Container.DialogItem, size: Size) -> Rect {
        switch dialog.container.dialogAlignment {
        case .topLeft: return Rect(topRight: bounds.topLeft, size: size)
        case .top: return Rect(bottom: bounds.top, size: size)
        case .topRight: return Rect(topLeft: bounds.topRight, size: size)
        case .centerLeft: return Rect(right: bounds.left, size: size)
        case .center: return Rect(center: bounds.center - Point(x: 0, y: size.height), size: size)
        case .centerRight: return Rect(left: bounds.right, size: size)
        case .bottomLeft: return Rect(bottomRight: bounds.bottomLeft, size: size)
        case .bottom: return Rect(top: bounds.bottom, size: size)
        case .bottomRight: return Rect(bottomLeft: bounds.bottomRight, size: size)
        }
    }
    
    @inline(__always)
    func _idleRect(bounds: Rect, dialog: UI.Container.DialogItem, size: Size) -> Rect {
        switch dialog.container.dialogAlignment {
        case .topLeft: return Rect(topLeft: bounds.topLeft, size: size)
        case .top: return Rect(top: bounds.top, size: size)
        case .topRight: return Rect(topRight: bounds.topRight, size: size)
        case .centerLeft: return Rect(left: bounds.left, size: size)
        case .center: return Rect(center: bounds.center, size: size)
        case .centerRight: return Rect(right: bounds.right, size: size)
        case .bottomLeft: return Rect(bottomLeft: bounds.bottomLeft, size: size)
        case .bottom: return Rect(bottom: bounds.bottom, size: size)
        case .bottomRight: return Rect(bottomRight: bounds.bottomRight, size: size)
        }
    }
    
    @inline(__always)
    func _dismissRect(bounds: Rect, dialog: UI.Container.DialogItem, size: Size) -> Rect {
        switch dialog.container.dialogAlignment {
        case .topLeft: return Rect(topRight: bounds.topLeft, size: size)
        case .top: return Rect(bottom: bounds.top, size: size)
        case .topRight: return Rect(topLeft: bounds.topRight, size: size)
        case .centerLeft: return Rect(right: bounds.left, size: size)
        case .center: return Rect(center: bounds.center + Point(x: 0, y: size.height), size: size)
        case .centerRight: return Rect(left: bounds.right, size: size)
        case .bottomLeft: return Rect(bottomRight: bounds.bottomLeft, size: size)
        case .bottom: return Rect(top: bounds.bottom, size: size)
        case .bottomRight: return Rect(bottomLeft: bounds.bottomRight, size: size)
        }
    }
    
    @inline(__always)
    func _offset(dialog: UI.Container.DialogItem, size: Size, delta: Point) -> Double {
        switch dialog.container.dialogAlignment {
        case .topLeft: return -delta.x
        case .top: return -delta.y
        case .topRight: return delta.x
        case .centerLeft: return -delta.x
        case .center: return delta.y
        case .centerRight: return delta.x
        case .bottomLeft: return -delta.x
        case .bottom: return delta.y
        case .bottomRight: return delta.x
        }
    }
    
    @inline(__always)
    func _size(dialog: UI.Container.DialogItem, size: Size) -> Double {
        switch dialog.container.dialogAlignment {
        case .topLeft: return size.width
        case .top: return size.height
        case .topRight: return size.width
        case .centerLeft: return size.width
        case .center: return size.height
        case .centerRight: return size.width
        case .bottomLeft: return size.width
        case .bottom: return size.height
        case .bottomRight: return size.width
        }
    }
    
    @inline(__always)
    func _progress(dialog: UI.Container.DialogItem, size: Size, delta: Point) -> Percent {
        let dialogOffset = self._offset(dialog: dialog, size: size, delta: delta)
        let dialogSize = self._size(dialog: dialog, size: size)
        if dialogOffset < 0 {
            return Percent(dialogOffset / pow(dialogSize, 1.25))
        }
        return Percent(dialogOffset / dialogSize)
    }
    
}
