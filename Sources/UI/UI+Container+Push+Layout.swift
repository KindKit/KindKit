//
//  KindKit
//

import Foundation

extension UI.Container.Push {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var state: UI.Container.Push.State {
            set {
                guard self._layout.state != newValue else { return }
                self._layout.state = newValue
                self.setNeedUpdate()
            }
            get { self._layout.state }
        }
        var inset: InsetFloat {
            set { self._layout.inset = newValue }
            get { self._layout.inset }
        }
        var parentInset: InsetFloat {
            set {
                guard self._layout.parentInset != newValue else { return }
                self._layout.parentInset = newValue
                self.setNeedUpdate()
            }
            get { self._layout.parentInset }
        }
        var contentInset: InsetFloat {
            set {
                guard self._layout.contentInset != newValue else { return }
                self._layout.contentInset = newValue
                self.setNeedUpdate()
            }
            get { self._layout.contentInset }
        }
        var content: UI.Layout.Item? {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        private var _layout: Queue
        private var _view: UI.View.Custom
        private var _viewItem: UI.Layout.Item
        
        init(
            inset: InsetFloat,
            content: UI.Layout.Item?
        ) {
            self.content = content
            self._layout = .init(inset: inset)
            self._view = .init().content(self._layout)
            self._viewItem = .init(self._view)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let content = self.content {
                content.frame = bounds
            }
            switch self._layout.state {
            case .empty:
                break
            case .idle(let push):
                let inset = self._inset(item: push)
                self._viewItem.frame = bounds.inset(inset)
            case .present(let push, _):
                let inset = self._inset(item: push)
                self._viewItem.frame = bounds.inset(inset)
            case .dismiss(let push, _):
                let inset = self._inset(item: push)
                self._viewItem.frame = bounds.inset(inset)
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
            items.append(self._viewItem)
            return items
        }
        
    }
    
}

private extension UI.Container.Push.Layout {
    
    func _inset(item: UI.Container.PushItem) -> InsetFloat {
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

extension UI.Container.Push.Layout {
    
    func duration(item: UI.Container.PushItem, velocity: Float) -> TimeInterval {
        return self._layout.duration(item: item, velocity: velocity)
    }
    
    func cancelDuration(item: UI.Container.PushItem, progress: PercentFloat, velocity: Float) -> TimeInterval {
        return self._layout.cancelDuration(item: item, progress: progress, velocity: velocity)
    }
    
}

extension UI.Container.Push.Layout {
    
    func delta(item: UI.Container.PushItem, begin: PointFloat, current: PointFloat) -> Float {
        return self._layout.delta(item: item, begin: begin, current: current)
    }
    
    func progress(item: UI.Container.PushItem, delta: Float) -> PercentFloat {
        return self._layout.progress(item: item, delta: delta)
    }
    
}
