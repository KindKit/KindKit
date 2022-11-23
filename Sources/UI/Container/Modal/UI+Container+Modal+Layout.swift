//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var state: State = .empty {
            didSet {
                guard self.state != oldValue else { return }
                switch oldValue {
                case .empty:
                    break
                case .idle(let modal):
                    self._cache[ObjectIdentifier(modal.view)] = nil
                case .present(let modal, _):
                    self._cache[ObjectIdentifier(modal.view)] = nil
                case .dismiss(let modal, _):
                    self._cache[ObjectIdentifier(modal.view)] = nil
                }
                self.setNeedUpdate()
            }
        }
        var inset: Inset = .zero {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        private var _cache: [ObjectIdentifier : Size] = [:]

        init(
            _ content: IUIView?
        ) {
            self.content = content
        }
        
        public func invalidate() {
            self._cache.removeAll(keepingCapacity: true)
        }
        
        public func invalidate(_ view: IUIView) {
            self._cache[ObjectIdentifier(view)] = nil
        }
        
        func layout(bounds: Rect) -> Size {
            if let content = self.content {
                content.frame = bounds
            }
            switch self.state {
            case .empty:
                break
            case .idle(let modal):
                let modalInset: Inset
                if let sheetInset = modal.sheetInset, let sheet = modal.sheetBackground {
                    modalInset = Inset(top: self.inset.top + sheetInset.top, left: sheetInset.left, right: sheetInset.right, bottom: sheetInset.bottom)
                    sheet.frame = bounds
                    sheet.alpha = 1
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let modalSize = self._size(view: modal.view, available: modalBounds.size)
                modal.view.frame = Rect(bottom: modalBounds.bottom, size: modalSize)
            case .present(let modal, let progress):
                let modalInset: Inset
                if let sheetInset = modal.sheetInset, let sheet = modal.sheetBackground {
                    modalInset = Inset(top: self.inset.top + sheetInset.top, left: sheetInset.left, right: sheetInset.right, bottom: sheetInset.bottom)
                    sheet.frame = bounds
                    sheet.alpha = progress.value
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let modalSize = self._size(view: modal.view, available: modalBounds.size)
                let beginRect = Rect(topLeft: bounds.bottomLeft, size: bounds.size)
                let endRect = Rect(bottom: modalBounds.bottom, size: modalSize)
                modal.view.frame = beginRect.lerp(endRect, progress: progress)
            case .dismiss(let modal, let progress):
                let modalInset: Inset
                if let sheetInset = modal.sheetInset, let sheet = modal.sheetBackground {
                    modalInset = Inset(top: self.inset.top + sheetInset.top, left: sheetInset.left, right: sheetInset.right, bottom: sheetInset.bottom)
                    sheet.frame = bounds
                    sheet.alpha = progress.invert.value
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let modalSize = self._size(view: modal.view, available: modalBounds.size)
                let beginRect = Rect(bottom: modalBounds.bottom, size: modalSize)
                let endRect = Rect(topLeft: bounds.bottomLeft, size: bounds.size)
                modal.view.frame = beginRect.lerp(endRect, progress: progress)
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
            switch self.state {
            case .empty: break
            case .idle(let modal):
                if let view = modal.sheetBackground {
                    views.append(view)
                }
                views.append(modal.view)
            case .present(let modal, _):
                if let view = modal.sheetBackground {
                    views.append(view)
                }
                views.append(modal.view)
            case .dismiss(let modal, _):
                if let view = modal.sheetBackground {
                    views.append(view)
                }
                views.append(modal.view)
            }
            return views
        }
        
    }
    
}

private extension UI.Container.Modal.Layout {
    
    @inline(__always)
    func _size(view: IUIView, available: Size) -> Size {
        if let cacheSize = self._cache[ObjectIdentifier(view)] {
            return cacheSize
        }
        let itemSize = view.size(available: available)
        self._cache[ObjectIdentifier(view)] = itemSize
        return itemSize
    }
    
}
