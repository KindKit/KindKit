//
//  KindKit
//

import Foundation

extension UI.Container.Group {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var bar: IUIView {
            didSet {
                guard self.bar !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barVisibility: Double {
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
        var barOffset: Double {
            didSet {
                guard self.barOffset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var barSize: Double

        init(
            state: State = .empty,
            bar: IUIView,
            barVisibility: Double,
            barHidden: Bool
        ) {
            self.state = state
            self.bar = bar
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.barOffset = 0
            self.barSize = 0
        }
        
        func layout(bounds: Rect) -> Size {
            let barSize = self.bar.size(available: Size(
                width: bounds.width,
                height: .infinity
            ))
            self.bar.frame = Rect(
                bottom: bounds.bottom,
                width: bounds.width,
                height: self.barOffset + (barSize.height * self.barVisibility)
            )
            self.barSize = barSize.height
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
        
        func views(bounds: Rect) -> [IUIView] {
            var views: [IUIView] = []
            if self.barHidden == false {
                views.append(self.bar)
            }
            switch self.state {
            case .empty: break
            case .idle(let current):
                views.insert(current.view, at: 0)
            case .forward(let current, let next, _):
                views.insert(contentsOf: [ current.view, next.view ], at: 0)
            case .backward(let current, let next, _):
                views.insert(contentsOf: [ next.view, current.view ], at: 0)
            }
            return views
        }
        
    }
    
}
