//
//  KindKit
//

import Foundation

extension UI.Container.Dialog {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var inset: InsetFloat {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: UI.Layout.Item? {
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
        var dialogItem: Item? {
            didSet {
                guard self.dialogItem !== oldValue else { return }
                self._dialogSize = nil
                self.setNeedUpdate()
            }
        }
        var dialogSize: SizeFloat? {
            self.updateIfNeeded()
            return self._dialogSize
        }
        
        private var _lastBoundsSize: SizeFloat?
        private var _dialogSize: SizeFloat?
        
        init(
            inset: InsetFloat,
            content: UI.Layout.Item?,
            state: State
        ) {
            self.inset = inset
            self.content = content
            self.state = state
        }
        
        func invalidate(item: UI.Layout.Item) {
            if self.dialogItem?.item == item {
                self._dialogSize = nil
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let lastBoundsSize = self._lastBoundsSize {
                if lastBoundsSize != bounds.size {
                    self._dialogSize = nil
                    self._lastBoundsSize = bounds.size
                }
            } else {
                self._dialogSize = nil
                self._lastBoundsSize = bounds.size
            }
            if let content = self.content {
                content.frame = bounds
            }
            if let dialog = self.dialogItem {
                if let backgroundItem = dialog.backgroundItem {
                    backgroundItem.frame = bounds
                }
                let availableBounds = bounds.inset(dialog.container.dialogInset)
                let size: SizeFloat
                if let dialogSize = self._dialogSize {
                    size = dialogSize
                } else {
                    size = self._size(bounds: availableBounds, dialog: dialog)
                    self._dialogSize = size
                }
                switch self.state {
                case .idle:
                    dialog.item.frame = self._idleRect(bounds: availableBounds, dialog: dialog, size: size)
                case .present(let progress):
                    let beginRect = self._presentRect(bounds: availableBounds, dialog: dialog, size: size)
                    let endRect = self._idleRect(bounds: availableBounds, dialog: dialog, size: size)
                    dialog.item.frame = beginRect.lerp(endRect, progress: progress)
                    if let view = dialog.item.view as? IUIViewAlphable {
                        view.alpha = progress.value
                    }
                    if let backgroundView = dialog.backgroundView {
                        backgroundView.alpha = progress.value
                    }
                case .dismiss(let progress):
                    let beginRect = self._idleRect(bounds: availableBounds, dialog: dialog, size: size)
                    let endRect = self._dismissRect(bounds: availableBounds, dialog: dialog, size: size)
                    dialog.item.frame = beginRect.lerp(endRect, progress: progress)
                    if let view = dialog.item.view as? IUIViewAlphable {
                        view.alpha = progress.invert.value
                    }
                    if let backgroundView = dialog.backgroundView {
                        backgroundView.alpha = progress.invert.value
                    }
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = []
            if let content = self.content {
                items.append(content)
            }
            if let dialogItem = self.dialogItem {
                if let backgroundItem = dialogItem.backgroundItem {
                    items.append(backgroundItem)
                }
                items.append(dialogItem.item)
            }
            return items
        }
        
    }
    
}

extension UI.Container.Dialog.Layout {
    
    @inline(__always)
    func _size(bounds: RectFloat, dialog: UI.Container.Dialog.Item) -> SizeFloat {
        let width, height: Float
        if dialog.container.dialogWidth == .fit && dialog.container.dialogHeight == .fit {
            let size = dialog.item.size(available: bounds.size)
            width = min(size.width, bounds.width)
            height = min(size.height, bounds.height)
        } else if dialog.container.dialogWidth == .fit {
            switch dialog.container.dialogHeight {
            case .fill(let before, let after): height = bounds.size.height - (before + after)
            case .fixed(let value): height = value
            case .fit: height = bounds.height
            }
            let size = dialog.item.size(available: SizeFloat(width: bounds.size.width, height: height))
            width = min(size.width, bounds.width)
        } else if dialog.container.dialogHeight == .fit {
            switch dialog.container.dialogWidth {
            case .fill(let before, let after): width = bounds.size.width - (before + after)
            case .fixed(let value): width = value
            case .fit: width = bounds.width
            }
            let size = dialog.item.size(available: SizeFloat(width: width, height: bounds.size.height))
            height = min(size.height, bounds.height)
        } else {
            switch dialog.container.dialogWidth {
            case .fill(let before, let after): width = bounds.size.width - (before + after)
            case .fixed(let value): width = value
            case .fit: width = bounds.width
            }
            switch dialog.container.dialogHeight {
            case .fill(let before, let after): height = bounds.size.height - (before + after)
            case .fixed(let value): height = value
            case .fit: height = bounds.height
            }
        }
        return Size(width: width, height: height)
    }
    
    @inline(__always)
    func _presentRect(bounds: RectFloat, dialog: UI.Container.Dialog.Item, size: SizeFloat) -> RectFloat {
        switch dialog.container.dialogAlignment {
        case .topLeft: return Rect(topRight: bounds.topLeft, size: size)
        case .top: return Rect(bottom: bounds.top, size: size)
        case .topRight: return Rect(topLeft: bounds.topRight, size: size)
        case .centerLeft: return Rect(right: bounds.left, size: size)
        case .center: return Rect(center: bounds.center - PointFloat(x: 0, y: size.height), size: size)
        case .centerRight: return Rect(left: bounds.right, size: size)
        case .bottomLeft: return Rect(bottomRight: bounds.bottomLeft, size: size)
        case .bottom: return Rect(top: bounds.bottom, size: size)
        case .bottomRight: return Rect(bottomLeft: bounds.bottomRight, size: size)
        }
    }
    
    @inline(__always)
    func _idleRect(bounds: RectFloat, dialog: UI.Container.Dialog.Item, size: SizeFloat) -> RectFloat {
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
    func _dismissRect(bounds: RectFloat, dialog: UI.Container.Dialog.Item, size: SizeFloat) -> RectFloat {
        switch dialog.container.dialogAlignment {
        case .topLeft: return Rect(topRight: bounds.topLeft, size: size)
        case .top: return Rect(bottom: bounds.top, size: size)
        case .topRight: return Rect(topLeft: bounds.topRight, size: size)
        case .centerLeft: return Rect(right: bounds.left, size: size)
        case .center: return Rect(center: bounds.center + PointFloat(x: 0, y: size.height), size: size)
        case .centerRight: return Rect(left: bounds.right, size: size)
        case .bottomLeft: return Rect(bottomRight: bounds.bottomLeft, size: size)
        case .bottom: return Rect(top: bounds.bottom, size: size)
        case .bottomRight: return Rect(bottomLeft: bounds.bottomRight, size: size)
        }
    }
    
    @inline(__always)
    func _offset(dialog: UI.Container.Dialog.Item, size: SizeFloat, delta: PointFloat) -> Float {
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
    func _size(dialog: UI.Container.Dialog.Item, size: SizeFloat) -> Float {
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
    func _progress(dialog: UI.Container.Dialog.Item, size: SizeFloat, delta: PointFloat) -> PercentFloat {
        let dialogOffset = self._offset(dialog: dialog, size: size, delta: delta)
        let dialogSize = self._size(dialog: dialog, size: size)
        if dialogOffset < 0 {
            return Percent(dialogOffset / pow(dialogSize, 1.25))
        }
        return Percent(dialogOffset / dialogSize)
    }
    
}
