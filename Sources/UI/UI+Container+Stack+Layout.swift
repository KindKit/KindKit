//
//  KindKit
//

import Foundation

extension UI.Container.Stack {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(_ state: State) {
            self.state = state
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            switch self.state {
            case .idle(let current):
                let currentSize = self._size(item: current, available: bounds.size)
                current.frame = Rect(topLeft: bounds.topLeft, size: currentSize)
            case .push(let current, let forward, let progress):
                let currentSize = self._size(item: current, available: bounds.size)
                let currentRect = Rect(topLeft: bounds.topLeft, size: currentSize)
                let forwardSize = self._size(item: forward, available: bounds.size)
                let forwardRect = Rect(topLeft: currentRect.topRight, size: forwardSize)
                let backwardRect = RectFloat(left: currentRect)
                current.frame = currentRect.lerp(backwardRect, progress: progress)
                forward.frame = forwardRect.lerp(currentRect, progress: progress)
            case .pop(let backward, let current, let progress):
                let currentSize = self._size(item: current, available: bounds.size)
                let currentRect = Rect(topLeft: bounds.topLeft, size: currentSize)
                let backwardSize = self._size(item: backward, available: bounds.size)
                let backwardRect = Rect(topRight: currentRect.topLeft, size: backwardSize)
                let forwardRect = RectFloat(right: currentRect)
                current.frame = currentRect.lerp(forwardRect, progress: progress)
                backward.frame = backwardRect.lerp(currentRect, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            switch self.state {
            case .idle(let current):
                return self._size(item: current, available: available)
            case .push(let current, let forward, let progress):
                let currentSize = self._size(item: current, available: available)
                let forwardSize = self._size(item: forward, available: available)
                return currentSize.lerp(forwardSize, progress: progress)
            case .pop(let backward, let current, let progress):
                let backwardSize = self._size(item: backward, available: available)
                let currentSize = self._size(item: current, available: available)
                return currentSize.lerp(backwardSize, progress: progress)
            }
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            switch self.state {
            case .idle(let current): return [ current ]
            case .push(let current, let forward, _): return [ current, forward ]
            case .pop(let backward, let current, _): return [ backward, current ]
            }
        }
        
    }
    
}

private extension UI.Container.Stack.Layout {
    
    @inline(__always)
    func _size(item: UI.Layout.Item, available: SizeFloat) -> SizeFloat {
        return item.size(available: available)
    }
    
}
