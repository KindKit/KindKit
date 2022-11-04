//
//  KindKit
//

import Foundation

extension UI.Container.Push {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var state: State = .empty {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var inset: InsetFloat {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var inheritedInset: InsetFloat = .zero {
            didSet {
                guard self.inheritedInset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: UI.Layout.Item? {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            inset: InsetFloat,
            content: UI.Layout.Item?
        ) {
            self.inset = inset
            self.content = content
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let content = self.content {
                content.frame = bounds
            }
            switch self.state {
            case .empty:
                break
            case .idle(let push):
                let inset = self.inset + self.inheritedInset
                push.item.frame = RectFloat(
                    x: bounds.origin.x + inset.left,
                    y: bounds.origin.y + inset.top,
                    width: bounds.size.width - (inset.left + inset.right),
                    height: push.size.height
                )
            case .present(let push, let progress):
                let inset = self.inset + self.inheritedInset
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
                let inset = self.inset + self.inheritedInset
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
            if let content = self.content {
                items.append(content)
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
            return self.inset.top + self.inheritedInset.top + item.size.height
        }
        
    }
    
}
