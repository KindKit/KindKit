//
//  KindKit
//

import KindUI

extension Container.Hamburger {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: IView {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var leading: IView? {
            didSet {
                guard self.leading !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var leadingSize: Double {
            didSet {
                guard self.leadingSize != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var trailing: IView? {
            didSet {
                guard self.trailing !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var trailingSize: Double {
            didSet {
                guard self.trailingSize != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            state: State = .idle,
            content: IView,
            leading: IView?,
            leadingSize: Double,
            trailing: IView?,
            trailingSize: Double
        ) {
            self.state = state
            self.content = content
            self.leading = leading
            self.leadingSize = leadingSize
            self.trailing = trailing
            self.trailingSize = trailingSize
        }
        
        func layout(bounds: Rect) -> Size {
            switch self.state {
            case .idle:
                self.content.frame = bounds
            case .leading(let progress):
                if let leading = self.leading {
                    let contentBeginFrame = bounds
                    let contentEndedFrame = Rect(
                        x: bounds.origin.x + self.leadingSize,
                        y: bounds.origin.y,
                        width: bounds.size.width,
                        height: bounds.size.height
                    )
                    let leadingBeginFrame = Rect(
                        x: bounds.origin.x - self.leadingSize,
                        y: bounds.origin.y,
                        width: self.leadingSize,
                        height: bounds.size.height
                    )
                    let leadingEndedFrame = Rect(
                        x: bounds.origin.x,
                        y: bounds.origin.y,
                        width: self.leadingSize,
                        height: bounds.size.height
                    )
                    self.content.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress)
                    leading.frame = leadingBeginFrame.lerp(leadingEndedFrame, progress: progress)
                } else {
                    self.content.frame = bounds
                }
            case .trailing(let progress):
                if let trailing = self.trailing {
                    let contentBeginFrame = bounds
                    let contentEndedFrame = Rect(
                        x: bounds.origin.x - self.trailingSize,
                        y: bounds.origin.y,
                        width: bounds.size.width,
                        height: bounds.size.height
                    )
                    let trailingBeginFrame = Rect(
                        x: bounds.origin.x + bounds.size.width,
                        y: bounds.origin.y,
                        width: self.trailingSize,
                        height: bounds.size.height
                    )
                    let trailingEndedFrame = Rect(
                        x: (bounds.origin.x + bounds.size.width) - self.trailingSize,
                        y: bounds.origin.y,
                        width: self.trailingSize,
                        height: bounds.size.height
                    )
                    self.content.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress)
                    trailing.frame = trailingBeginFrame.lerp(trailingEndedFrame, progress: progress)
                } else {
                    self.content.frame = bounds
                }
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IView] {
            var views: [IView] = [ self.content ]
            switch self.state {
            case .leading where self.leading != nil:
                views.insert(self.leading!, at: 0)
            case .trailing where self.trailing != nil:
                views.insert(self.trailing!, at: 0)
            default:
                break
            }
            return views
        }
        
    }
    
}
