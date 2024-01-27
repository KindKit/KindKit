//
//  KindKit
//

import KindUI

extension Container.Book {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            state: State = .empty
        ) {
            self.state = state
        }
        
        func layout(bounds: Rect) -> Size {
            let forwardFrame = Rect(topLeft: bounds.topRight, size: bounds.size)
            let currentFrame = bounds
            let backwardFrame = Rect(topRight: bounds.topLeft, size: bounds.size)
            switch self.state {
            case .empty:
                break
            case .idle(let current):
                current.view.frame = bounds
            case .forward(let current, let next, let progress):
                current.view.frame = currentFrame.lerp(backwardFrame, progress: progress)
                next.view.frame = forwardFrame.lerp(currentFrame, progress: progress)
            case .backward(let current, let next, let progress):
                current.view.frame = currentFrame.lerp(forwardFrame, progress: progress)
                next.view.frame = backwardFrame.lerp(currentFrame, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IView] {
            switch self.state {
            case .empty: return []
            case .idle(let current): return [ current.view ]
            case .forward(let current, let next, _): return [ current.view, next.view ]
            case .backward(let current, let next, _): return [ next.view, current.view ]
            }
        }
        
    }
    
}
