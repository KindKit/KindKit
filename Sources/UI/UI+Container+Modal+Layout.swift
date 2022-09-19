//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var inset: InsetFloat = .zero {
            didSet { self.setNeedUpdate() }
        }
        var contentItem: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
        }
        var state: State = .empty {
            didSet { self.setNeedUpdate() }
        }

        init(
            _ contentItem: UI.Layout.Item?
        ) {
            self.contentItem = contentItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let contentItem = self.contentItem {
                contentItem.frame = bounds
            }
            switch self.state {
            case .empty:
                break
            case .idle(let modal):
                if let sheetInset = modal.sheetInset, let view = modal.sheetBackgroundView, let item = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    modal.item.frame = bounds.inset(inset)
                    view.alpha = 1
                    item.frame = bounds
                } else {
                    modal.item.frame = bounds
                }
            case .present(let modal, let progress):
                if let sheetInset = modal.sheetInset, let view = modal.sheetBackgroundView, let item = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    let beginRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    let endRect = bounds.inset(inset)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                    view.alpha = progress.value
                    item.frame = bounds
                } else {
                    let beginRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    let endRect = bounds
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                }
            case .dismiss(let modal, let progress):
                if let sheetInset = modal.sheetInset, let view = modal.sheetBackgroundView, let item = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    let beginRect = bounds.inset(inset)
                    let endRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                    view.alpha = progress.invert.value
                    item.frame = bounds
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
            if let contentItem = self.contentItem {
                items.append(contentItem)
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
