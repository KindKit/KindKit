//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var state: State = .empty {
            didSet {
                guard self.state != oldValue else { return }
                switch oldValue {
                case .empty:
                    break
                case .idle(let modal):
                    self._cache[modal.item] = nil
                case .present(let modal, _):
                    self._cache[modal.item] = nil
                case .dismiss(let modal, _):
                    self._cache[modal.item] = nil
                }
                self.setNeedUpdate()
            }
        }
        var inset: InsetFloat = .zero {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: UI.Layout.Item? {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        private var _cache: [UI.Layout.Item : SizeFloat] = [:]

        init(
            _ content: UI.Layout.Item?
        ) {
            self.content = content
        }
        
        public func invalidate(item: UI.Layout.Item) {
            self._cache[item] = nil
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let content = self.content {
                content.frame = bounds
            }
            switch self.state {
            case .empty:
                break
            case .idle(let modal):
                let modalInset: InsetFloat
                if let sheetInset = modal.sheetInset, let sheet = modal.sheetBackground, let sheetItem = modal.sheetBackgroundItem {
                    modalInset = InsetFloat(top: self.inset.top + sheetInset.top, left: sheetInset.left, right: sheetInset.right, bottom: sheetInset.bottom)
                    sheet.alpha = 1
                    sheetItem.frame = bounds
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let modalSize = self._size(item: modal.item, available: modalBounds.size)
                modal.item.frame = Rect(bottom: modalBounds.bottom, size: modalSize)
            case .present(let modal, let progress):
                let modalInset: InsetFloat
                if let sheetInset = modal.sheetInset, let sheet = modal.sheetBackground, let sheetItem = modal.sheetBackgroundItem {
                    modalInset = InsetFloat(top: self.inset.top + sheetInset.top, left: sheetInset.left, right: sheetInset.right, bottom: sheetInset.bottom)
                    sheet.alpha = progress.value
                    sheetItem.frame = bounds
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let modalSize = self._size(item: modal.item, available: modalBounds.size)
                let beginRect = Rect(topLeft: bounds.bottomLeft, size: bounds.size)
                let endRect = Rect(bottom: modalBounds.bottom, size: modalSize)
                modal.item.frame = beginRect.lerp(endRect, progress: progress)
            case .dismiss(let modal, let progress):
                let modalInset: InsetFloat
                if let sheetInset = modal.sheetInset, let sheet = modal.sheetBackground, let sheetItem = modal.sheetBackgroundItem {
                    modalInset = InsetFloat(top: self.inset.top + sheetInset.top, left: sheetInset.left, right: sheetInset.right, bottom: sheetInset.bottom)
                    sheet.alpha = progress.invert.value
                    sheetItem.frame = bounds
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let modalSize = self._size(item: modal.item, available: modalBounds.size)
                let beginRect = Rect(bottom: modalBounds.bottom, size: modalSize)
                let endRect = Rect(topLeft: bounds.bottomLeft, size: bounds.size)
                modal.item.frame = beginRect.lerp(endRect, progress: progress)
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
            switch self.state {
            case .empty: break
            case .idle(let modal):
                if let item = modal.sheetBackgroundItem {
                    items.append(item)
                }
                items.append(modal.item)
            case .present(let modal, _):
                if let item = modal.sheetBackgroundItem {
                    items.append(item)
                }
                items.append(modal.item)
            case .dismiss(let modal, _):
                if let item = modal.sheetBackgroundItem {
                    items.append(item)
                }
                items.append(modal.item)
            }
            return items
        }
        
    }
    
}

private extension UI.Container.Modal.Layout {
    
    @inline(__always)
    func _size(item: UI.Layout.Item, available: SizeFloat) -> SizeFloat {
        if let cacheSize = self._cache[item] {
            return cacheSize
        }
        let itemSize = item.size(available: available)
        self._cache[item] = itemSize
        return itemSize
    }
    
}
