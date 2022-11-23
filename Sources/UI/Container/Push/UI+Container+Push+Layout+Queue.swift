//
//  KindKit
//

import Foundation

extension UI.Container.Push.Layout {
    
    final class Queue : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var state: UI.Container.Push.State = .empty {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var inset: Inset {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var parentInset: Inset = .zero {
            didSet {
                guard self.parentInset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var contentInset: Inset = .zero {
            didSet {
                guard self.contentInset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            inset: Inset
        ) {
            self.inset = inset
        }
        
        func layout(bounds: Rect) -> Size {
            switch self.state {
            case .empty:
                break
            case .idle(let push):
                push.view.frame = self._endRect(bounds: bounds, item: push)
            case .present(let push, let progress):
                let beginRect = self._beginRect(bounds: bounds, item: push)
                let endRect = self._endRect(bounds: bounds, item: push)
                push.view.frame = beginRect.lerp(endRect, progress: progress)
            case .dismiss(let push, let progress):
                let beginRect = self._endRect(bounds: bounds, item: push)
                let endRect = self._beginRect(bounds: bounds, item: push)
                push.view.frame = beginRect.lerp(endRect, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IUIView] {
            switch self.state {
            case .empty: return []
            case .idle(let push): return [ push.view ]
            case .present(let push, _): return [ push.view ]
            case .dismiss(let push, _): return [ push.view ]
            }
        }
        
    }
    
}

private extension UI.Container.Push.Layout.Queue {
    
    func _beginRect(bounds: Rect, item: UI.Container.PushItem) -> Rect {
        switch item.container.pushPlacement {
        case .top: return .init(bottom: bounds.top, size: item.viewSize)
        case .bottom: return .init(top: bounds.bottom, size: item.viewSize)
        }
    }
    
    func _endRect(bounds: Rect, item: UI.Container.PushItem) -> Rect {
        let inset = self._inset(item: item)
        let frame = bounds.inset(inset)
        switch item.container.pushPlacement {
        case .top: return .init(top: frame.top, size: item.viewSize)
        case .bottom: return .init(bottom: frame.bottom, size: item.viewSize)
        }
    }
    
    func _inset(item: UI.Container.PushItem) -> Inset {
        let extraInset: Inset
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
    
    func _size(item: UI.Container.PushItem) -> Double {
        let inset = self._inset(item: item)
        switch item.container.pushPlacement {
        case .top: return inset.top + item.viewSize.height
        case .bottom: return inset.bottom + item.viewSize.height
        }
    }
    
}

extension UI.Container.Push.Layout.Queue {
    
    func duration(item: UI.Container.PushItem, velocity: Double) -> TimeInterval {
        let size = self._size(item: item)
        return TimeInterval(size / velocity)
    }
    
    func cancelDuration(item: UI.Container.PushItem, progress: Percent, velocity: Double) -> TimeInterval {
        let size = self._size(item: item)
        return TimeInterval((size * progress.value) / velocity)
    }
    
}

extension UI.Container.Push.Layout.Queue {
    
    func delta(item: UI.Container.PushItem, begin: Point, current: Point) -> Double {
        switch item.container.pushPlacement {
        case .top: return begin.y - current.y
        case .bottom: return current.y - begin.y
        }
    }
    
    func progress(item: UI.Container.PushItem, delta: Double) -> Percent {
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
