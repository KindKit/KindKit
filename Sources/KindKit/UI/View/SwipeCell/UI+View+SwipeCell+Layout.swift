//
//  KindKit
//

import Foundation

extension UI.View.SwipeCell {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var state: State = .idle {
            didSet { self.setNeedUpdate() }
        }
        var background: IUIView? {
            didSet { self.setNeedForceUpdate() }
        }
        var content: IUIView? {
            didSet { self.setNeedForceUpdate() }
        }
        var leading: IUIView? {
            didSet { self.setNeedForceUpdate() }
        }
        var leadingSize: Double = 0 {
            didSet { self.setNeedForceUpdate() }
        }
        var trailing: IUIView? {
            didSet { self.setNeedForceUpdate() }
        }
        var trailingSize: Double = 0 {
            didSet { self.setNeedForceUpdate() }
        }

        init() {
        }
        
        func layout(bounds: Rect) -> Size {
            self.background?.frame = bounds
            switch self.state {
            case .idle:
                self.content?.frame = bounds
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
                    self.content?.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress)
                    leading.frame = leadingBeginFrame.lerp(leadingEndedFrame, progress: progress)
                } else {
                    self.content?.frame = bounds
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
                    self.content?.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress)
                    trailing.frame = trailingBeginFrame.lerp(trailingEndedFrame, progress: progress)
                } else {
                    self.content?.frame = bounds
                }
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            guard let content = self.content else { return .zero }
            let contentSize = content.size(available: available)
            switch self.state {
            case .idle:
                break
            case .leading:
                if let leading = self.leading {
                    let leadingSize = leading.size(available: Size(width: self.leadingSize, height: contentSize.height))
                    return Size(width: available.width, height: max(contentSize.height, leadingSize.height))
                }
            case .trailing:
                if let trailing = self.trailing {
                    let trailingSize = trailing.size(available: Size(width: self.trailingSize, height: contentSize.height))
                    return Size(width: available.width, height: max(contentSize.height, trailingSize.height))
                }
            }
            return Size(width: available.width, height: contentSize.height)
        }
        
        func views(bounds: Rect) -> [IUIView] {
            switch self.state {
            case .idle:
                if let background = self.background, let content = self.content {
                    return [ background, content ]
                } else if let background = self.background {
                    return [ background ]
                } else if let content = self.content {
                    return [ content ]
                }
            case .leading:
                if let background = self.background, let content = self.content {
                    if let leading = self.leading {
                        return [ background, leading, content ]
                    }
                    return [ background, content ]
                } else if let background = self.background {
                    if let leading = self.leading {
                        return [ background, leading ]
                    }
                    return [ background ]
                } else if let content = self.content {
                    if let leading = self.leading {
                        return [ leading, content ]
                    }
                    return [ content ]
                }
            case .trailing:
                if let background = self.background, let content = self.content {
                    if let trailing = self.trailing {
                        return [ background, trailing, content ]
                    }
                    return [ background, content ]
                } else if let background = self.background {
                    if let trailing = self.trailing {
                        return [ background, trailing ]
                    }
                    return [ background ]
                } else if let content = self.content {
                    if let trailing = self.trailing {
                        return [ trailing, content ]
                    }
                    return [ content ]
                }
            }
            return []
        }
        
    }
    
}

extension UI.View.SwipeCell.Layout {
    
    enum State {
        
        case idle
        case leading(progress: Percent)
        case trailing(progress: Percent)
        
    }
    
}
