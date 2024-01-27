//
//  KindKit
//

import KindUI

extension Container.Stack {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(_ state: State) {
            self.state = state
        }
        
        func layout(bounds: Rect) -> Size {
            switch self.state {
            case .idle(let current):
                let currentSize = current.view.size(available: bounds.size)
                current.view.frame = Rect(topLeft: bounds.topLeft, size: currentSize)
            case .push(let current, let forward, let progress):
                let currentSize = current.view.size(available: bounds.size)
                let currentRect = Rect(topLeft: bounds.topLeft, size: currentSize)
                let forwardSize = forward.view.size(available: bounds.size)
                let forwardRect = Rect(topLeft: currentRect.topRight, size: forwardSize)
                let backwardRect = Rect(left: currentRect)
                current.view.frame = currentRect.lerp(backwardRect, progress: progress)
                forward.view.frame = forwardRect.lerp(currentRect, progress: progress)
            case .pop(let backward, let current, let progress):
                let currentSize = current.view.size(available: bounds.size)
                let currentRect = Rect(topLeft: bounds.topLeft, size: currentSize)
                let backwardSize = backward.view.size(available: bounds.size)
                let backwardRect = Rect(topRight: currentRect.topLeft, size: backwardSize)
                let forwardRect = Rect(right: currentRect)
                current.view.frame = currentRect.lerp(forwardRect, progress: progress)
                backward.view.frame = backwardRect.lerp(currentRect, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            switch self.state {
            case .idle(let current):
                return current.view.size(available: available)
            case .push(let current, let forward, let progress):
                let currentSize = current.view.size(available: available)
                let forwardSize = forward.view.size(available: available)
                return currentSize.lerp(forwardSize, progress: progress)
            case .pop(let backward, let current, let progress):
                let backwardSize = backward.view.size(available: available)
                let currentSize = current.view.size(available: available)
                return currentSize.lerp(backwardSize, progress: progress)
            }
        }
        
        func views(bounds: Rect) -> [IView] {
            switch self.state {
            case .idle(let current): return [ current.view ]
            case .push(let current, let forward, _): return [ current.view, forward.view ]
            case .pop(let backward, let current, _): return [ backward.view, current.view ]
            }
        }
        
    }
    
}
