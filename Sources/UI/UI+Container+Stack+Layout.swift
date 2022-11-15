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
                let currentSize = current.viewItem.size(available: bounds.size)
                current.viewItem.frame = Rect(topLeft: bounds.topLeft, size: currentSize)
            case .push(let current, let forward, let progress):
                let currentSize = current.viewItem.size(available: bounds.size)
                let currentRect = Rect(topLeft: bounds.topLeft, size: currentSize)
                let forwardSize = forward.viewItem.size(available: bounds.size)
                let forwardRect = Rect(topLeft: currentRect.topRight, size: forwardSize)
                let backwardRect = RectFloat(left: currentRect)
                current.viewItem.frame = currentRect.lerp(backwardRect, progress: progress)
                forward.viewItem.frame = forwardRect.lerp(currentRect, progress: progress)
            case .pop(let backward, let current, let progress):
                let currentSize = current.viewItem.size(available: bounds.size)
                let currentRect = Rect(topLeft: bounds.topLeft, size: currentSize)
                let backwardSize = backward.viewItem.size(available: bounds.size)
                let backwardRect = Rect(topRight: currentRect.topLeft, size: backwardSize)
                let forwardRect = RectFloat(right: currentRect)
                current.viewItem.frame = currentRect.lerp(forwardRect, progress: progress)
                backward.viewItem.frame = backwardRect.lerp(currentRect, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            switch self.state {
            case .idle(let current):
                return current.viewItem.size(available: available)
            case .push(let current, let forward, let progress):
                let currentSize = current.viewItem.size(available: available)
                let forwardSize = forward.viewItem.size(available: available)
                return currentSize.lerp(forwardSize, progress: progress)
            case .pop(let backward, let current, let progress):
                let backwardSize = backward.viewItem.size(available: available)
                let currentSize = current.viewItem.size(available: available)
                return currentSize.lerp(backwardSize, progress: progress)
            }
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            switch self.state {
            case .idle(let current): return [ current.viewItem ]
            case .push(let current, let forward, _): return [ current.viewItem, forward.viewItem ]
            case .pop(let backward, let current, _): return [ backward.viewItem, current.viewItem ]
            }
        }
        
    }
    
}
