//
//  KindKit
//

import Foundation

extension UI.Container.Stack {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var state: State {
            didSet { self.setNeedUpdate() }
        }
        
        init(state: State = .empty) {
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
                current.frame = currentFrame
            case .push(let current, let forward, let progress):
                forward.frame = forwardFrame.lerp(currentFrame, progress: progress)
                current.frame = currentFrame.lerp(backwardFrame, progress: progress)
            case .pop(let backward, let current, let progress):
                current.frame = currentFrame.lerp(forwardFrame, progress: progress)
                backward.frame = backwardFrame.lerp(currentFrame, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            switch self.state {
            case .empty: return []
            case .idle(let current): return [ current ]
            case .push(let current, let forward, _): return [ current, forward ]
            case .pop(let backward, let current, _): return [ backward, current ]
            }
        }
        
    }
    
}
