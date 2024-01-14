//
//  KindKit
//

import KindUI

extension Container.Push {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var state: Container.Push.State {
            set {
                guard self._layout.state != newValue else { return }
                self._layout.state = newValue
                self.setNeedUpdate()
            }
            get { self._layout.state }
        }
        var inset: Inset {
            set { self._layout.inset = newValue }
            get { self._layout.inset }
        }
        var parentInset: Inset {
            set {
                guard self._layout.parentInset != newValue else { return }
                self._layout.parentInset = newValue
                self.setNeedUpdate()
            }
            get { self._layout.parentInset }
        }
        var contentInset: Inset {
            set {
                guard self._layout.contentInset != newValue else { return }
                self._layout.contentInset = newValue
                self.setNeedUpdate()
            }
            get { self._layout.contentInset }
        }
        var content: IView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        private var _layout: Queue
        private var _view: CustomView
        
        init(
            inset: Inset,
            content: IView?
        ) {
            self.content = content
            self._layout = .init(inset: inset)
            self._view = .init().content(self._layout)
        }
        
        func layout(bounds: Rect) -> Size {
            if let content = self.content {
                content.frame = bounds
            }
            switch self._layout.state {
            case .empty:
                break
            case .idle(let push):
                let inset = self._inset(item: push)
                self._view.frame = bounds.inset(inset)
            case .present(let push, _):
                let inset = self._inset(item: push)
                self._view.frame = bounds.inset(inset)
            case .dismiss(let push, _):
                let inset = self._inset(item: push)
                self._view.frame = bounds.inset(inset)
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IView] {
            var views: [IView] = []
            if let content = self.content {
                views.append(content)
            }
            views.append(self._view)
            return views
        }
        
    }
    
}

private extension Container.Push.Layout {
    
    func _inset(item: Container.PushItem) -> Inset {
        if item.container.pushOptions.contains(.useContentInset) == true {
            return .init(
                top: self.parentInset.top != self.contentInset.top ? self.contentInset.top : 0,
                left: self.parentInset.left != self.contentInset.left ? self.contentInset.left : 0,
                right: self.parentInset.right != self.contentInset.right ? self.contentInset.right : 0,
                bottom: self.parentInset.bottom != self.contentInset.bottom ? self.contentInset.bottom : 0
            )
        }
        return .zero
    }
    
}

extension Container.Push.Layout {
    
    func duration(item: Container.PushItem, velocity: Double) -> TimeInterval {
        return self._layout.duration(item: item, velocity: velocity)
    }
    
    func cancelDuration(item: Container.PushItem, progress: Percent, velocity: Double) -> TimeInterval {
        return self._layout.cancelDuration(item: item, progress: progress, velocity: velocity)
    }
    
}

extension Container.Push.Layout {
    
    func delta(item: Container.PushItem, begin: Point, current: Point) -> Double {
        return self._layout.delta(item: item, begin: begin, current: current)
    }
    
    func state(item: Container.PushItem, delta: Double) -> Container.Push.State {
        return self._layout.state(item: item, delta: delta)
    }
    
}
