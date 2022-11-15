//
//  KindKit
//

import Foundation

extension UI.Container.Push.Layout {
    
    final class Queue : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var state: UI.Container.Push.State = .empty {
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
        var parentInset: InsetFloat = .zero {
            didSet {
                guard self.parentInset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var contentInset: InsetFloat = .zero {
            didSet {
                guard self.contentInset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            inset: InsetFloat
        ) {
            self.inset = inset
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            switch self.state {
            case .empty:
                break
            case .idle(let push):
                push.viewItem.frame = self._endRect(bounds: bounds, item: push)
            case .present(let push, let progress):
                let beginRect = self._beginRect(bounds: bounds, item: push)
                let endRect = self._endRect(bounds: bounds, item: push)
                push.viewItem.frame = beginRect.lerp(endRect, progress: progress)
            case .dismiss(let push, let progress):
                let beginRect = self._endRect(bounds: bounds, item: push)
                let endRect = self._beginRect(bounds: bounds, item: push)
                push.viewItem.frame = beginRect.lerp(endRect, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            switch self.state {
            case .empty: return []
            case .idle(let push): return [ push.viewItem ]
            case .present(let push, _): return [ push.viewItem ]
            case .dismiss(let push, _): return [ push.viewItem ]
            }
        }
        
    }
    
}

private extension UI.Container.Push.Layout.Queue {
    
    func _beginRect(bounds: RectFloat, item: UI.Container.PushItem) -> RectFloat {
        switch item.container.pushPlacement {
        case .top: return .init(bottom: bounds.top, size: item.viewSize)
        case .bottom: return .init(top: bounds.bottom, size: item.viewSize)
        }
    }
    
    func _endRect(bounds: RectFloat, item: UI.Container.PushItem) -> RectFloat {
        let inset = self._inset(item: item)
        let frame = bounds.inset(inset)
        switch item.container.pushPlacement {
        case .top: return .init(top: frame.top, size: item.viewSize)
        case .bottom: return .init(bottom: frame.bottom, size: item.viewSize)
        }
    }
    
    func _inset(item: UI.Container.PushItem) -> InsetFloat {
        let extraInset: InsetFloat
        if item.container.pushOptions.contains(.useContentInset) == false {
            extraInset = self.parentInset
        } else {
            extraInset = .init(
                top: self.parentInset.top == self.contentInset.top ? self.contentInset.top : 0,
                left: self.parentInset.left == self.contentInset.left ? self.contentInset.left : 0,
                right: self.parentInset.right == self.contentInset.right ? self.contentInset.right : 0,
                bottom: self.parentInset.bottom == self.contentInset.bottom ? self.contentInset.bottom : 0
            )
        }
        return self.inset + extraInset
    }
    
    func _size(item: UI.Container.PushItem) -> Float {
        let inset = self._inset(item: item)
        switch item.container.pushPlacement {
        case .top: return inset.top + item.viewSize.height
        case .bottom: return inset.bottom + item.viewSize.height
        }
    }
    
}

extension UI.Container.Push.Layout.Queue {
    
    func duration(item: UI.Container.PushItem, velocity: Float) -> TimeInterval {
        let size = self._size(item: item)
        return TimeInterval(size / velocity)
    }
    
    func cancelDuration(item: UI.Container.PushItem, progress: PercentFloat, velocity: Float) -> TimeInterval {
        let size = self._size(item: item)
        return TimeInterval((size * progress.value) / velocity)
    }
    
}

extension UI.Container.Push.Layout.Queue {
    
    func delta(item: UI.Container.PushItem, begin: PointFloat, current: PointFloat) -> Float {
        switch item.container.pushPlacement {
        case .top: return begin.y - current.y
        case .bottom: return current.y - begin.y
        }
    }
    
    func progress(item: UI.Container.PushItem, delta: Float) -> PercentFloat {
        if delta ~~ .zero {
            return .zero
        }
        let size = self._size(item: item)
        if delta < 0 {
            return .one + Percent(-delta / pow(size, 1.5))
        }
        return Percent(delta / size)
    }
    
}
