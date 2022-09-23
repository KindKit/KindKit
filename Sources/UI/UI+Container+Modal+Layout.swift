//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var state: State = .empty {
            didSet { self.setNeedUpdate() }
        }
        var inset: InsetFloat = .zero {
            didSet { self.setNeedUpdate() }
        }
        var content: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
        }

        init(
            _ content: UI.Layout.Item?
        ) {
            self.content = content
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let content = self.content {
                content.frame = bounds
            }
            switch self.state {
            case .empty:
                break
            case .idle(let modal):
                if let sheetInset = modal.sheetInset, let sheetView = modal.sheetBackground, let sheetItem = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    modal.item.frame = bounds.inset(inset)
                    sheetView.alpha = 1
                    sheetItem.frame = bounds
                } else {
                    modal.item.frame = bounds
                }
            case .present(let modal, let progress):
                if let sheetInset = modal.sheetInset, let sheetView = modal.sheetBackground, let sheetItem = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    let beginRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    let endRect = bounds.inset(inset)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                    sheetView.alpha = progress.value
                    sheetItem.frame = bounds
                } else {
                    let beginRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    let endRect = bounds
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                }
            case .dismiss(let modal, let progress):
                if let sheetInset = modal.sheetInset, let sheetView = modal.sheetBackground, let sheetItem = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    let beginRect = bounds.inset(inset)
                    let endRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                    sheetView.alpha = progress.invert.value
                    sheetItem.frame = bounds
                } else {
                    let beginRect = bounds
                    let endRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
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
