//
//  KindKit
//

import Foundation

extension UI.Container.Book {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
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
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let forwardFrame = RectFloat(topLeft: bounds.topRight, size: bounds.size)
            let currentFrame = bounds
            let backwardFrame = RectFloat(topRight: bounds.topLeft, size: bounds.size)
            switch self.state {
            case .empty:
                break
            case .idle(let current):
                current.viewItem.frame = bounds
            case .forward(let current, let next, let progress):
                current.viewItem.frame = currentFrame.lerp(backwardFrame, progress: progress)
                next.viewItem.frame = forwardFrame.lerp(currentFrame, progress: progress)
            case .backward(let current, let next, let progress):
                current.viewItem.frame = currentFrame.lerp(forwardFrame, progress: progress)
                next.viewItem.frame = backwardFrame.lerp(currentFrame, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            switch self.state {
            case .empty: return []
            case .idle(let current): return [ current.viewItem ]
            case .forward(let current, let next, _): return [ current.viewItem, next.viewItem ]
            case .backward(let current, let next, _): return [ next.viewItem, current.viewItem ]
            }
        }
        
    }
    
}
