//
//  KindKit
//

import Foundation

extension UI.Container.Push {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var additionalInset: InsetFloat {
            didSet { self.setNeedUpdate() }
        }
        var containerInset: InsetFloat {
            didSet { self.setNeedUpdate() }
        }
        var contentItem: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
        }
        var state: State {
            didSet { self.setNeedUpdate() }
        }
        
        init(
            additionalInset: InsetFloat,
            containerInset: InsetFloat,
            contentItem: UI.Layout.Item?,
            state: State
        ) {
            self.additionalInset = additionalInset
            self.containerInset = containerInset
            self.contentItem = contentItem
            self.state = state
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let contentItem = self.contentItem {
                contentItem.frame = bounds
            }
            switch self.state {
            case .empty:
                break
            case .idle(let push):
                let inset = self.additionalInset + self.containerInset
                push.item.frame = RectFloat(
                    x: bounds.origin.x + inset.left,
                    y: bounds.origin.y + inset.top,
                    width: bounds.size.width - (inset.left + inset.right),
                    height: push.size.height
                )
            case .present(let push, let progress):
                let inset = self.additionalInset + self.containerInset
                let beginRect = RectFloat(
                    x: bounds.origin.x + inset.left,
                    y: bounds.origin.y - push.size.height,
                    width: bounds.size.width - (inset.left + inset.right),
                    height: push.size.height
                )
                let endRect = RectFloat(
                    x: bounds.origin.x + inset.left,
                    y: bounds.origin.y + inset.top,
                    width: bounds.size.width - (inset.left + inset.right),
                    height: push.size.height
                )
                push.item.frame = beginRect.lerp(endRect, progress: progress)
            case .dismiss(let push, let progress):
                let inset = self.additionalInset + self.containerInset
                let beginRect = RectFloat(
                    x: bounds.origin.x + inset.left,
                    y: bounds.origin.y + inset.top,
                    width: bounds.size.width - (inset.left + inset.right),
                    height: push.size.height
                )
                let endRect = RectFloat(
                    x: bounds.origin.x + inset.left,
                    y: bounds.origin.y - push.size.height,
                    width: bounds.size.width - (inset.left + inset.right),
                    height: push.size.height
                )
                push.item.frame = beginRect.lerp(endRect, progress: progress)
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
            case .idle(let push): items.append(push.item)
            case .present(let push, _): items.append(push.item)
            case .dismiss(let push, _): items.append(push.item)
            }
            return items
        }
        
        func height(item: UI.Container.Push.Item) -> Float {
            return item.size.height + self.additionalInset.top + self.containerInset.top
        }
        
    }
    
}