//
//  KindKit
//

import Foundation

extension UI.Container.Group {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var bar: UI.Layout.Item {
            didSet {
                guard self.bar != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barVisibility: Float {
            didSet {
                guard self.barVisibility != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barHidden: Bool {
            didSet {
                guard self.barHidden != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barOffset: Float {
            didSet {
                guard self.barOffset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barSize: Float

        init(
            state: State = .empty,
            bar: UI.Layout.Item,
            barVisibility: Float,
            barHidden: Bool
        ) {
            self.state = state
            self.bar = bar
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.barOffset = 0
            self.barSize = 0
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let barSize = self.bar.size(available: SizeFloat(
                width: bounds.width,
                height: .infinity
            ))
            self.bar.frame = RectFloat(
                bottom: bounds.bottom,
                width: bounds.width,
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
                items.append(self.bar)
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
