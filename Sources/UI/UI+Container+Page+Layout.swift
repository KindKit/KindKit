//
//  KindKit
//

import Foundation

extension UI.Container.Page {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var barOffset: Float {
            didSet { self.setNeedUpdate() }
        }
        var barSize: Float
        var barVisibility: Float {
            didSet { self.setNeedUpdate() }
        }
        var barHidden: Bool {
            didSet { self.setNeedUpdate() }
        }
        var barItem: UI.Layout.Item {
            didSet { self.setNeedUpdate() }
        }
        var state: State {
            didSet { self.setNeedUpdate() }
        }
        
        init(
            barItem: UI.Layout.Item,
            barVisibility: Float,
            barHidden: Bool,
            state: State = .empty
        ) {
            self.barOffset = 0
            self.barSize = 0
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.barItem = barItem
            self.state = state
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let barSize = self.barItem.size(available: SizeFloat(
                width: bounds.width,
                height: .infinity
            ))
            self.barItem.frame = RectFloat(
                x: bounds.origin.x,
                y: bounds.origin.y,
                width: bounds.size.width,
                height: self.barOffset + (barSize.height * self.barVisibility)
            )
            self.barSize = barSize.height
            let forwardFrame = RectFloat(topLeft: bounds.topRight, size: bounds.size)
            let currentFrame = bounds
            let backwardFrame = RectFloat(topRight: bounds.topLeft, size: bounds.size)
            switch self.state {
            case .empty:
                break
            case .idle(let current):
                current.frame = bounds
            case .forward(let current, let next, let progress):
                current.frame = currentFrame.lerp(backwardFrame, progress: progress)
                next.frame = forwardFrame.lerp(currentFrame, progress: progress)
            case .backward(let current, let next, let progress):
                current.frame = currentFrame.lerp(forwardFrame, progress: progress)
                next.frame = backwardFrame.lerp(currentFrame, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = []
            if self.barHidden == false {
                items.append(self.barItem)
            }
            switch self.state {
            case .empty: break
            case .idle(let current):
                items.insert(current, at: 0)
            case .forward(let current, let next, _):
                items.insert(contentsOf: [ current, next ], at: 0)
            case .backward(let current, let next, _):
                items.insert(contentsOf: [ next, current ], at: 0)
            }
            return items
        }
        
    }
    
}
