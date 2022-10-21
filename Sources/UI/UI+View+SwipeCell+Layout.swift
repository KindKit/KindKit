//
//  KindKit
//

import Foundation

extension UI.View.SwipeCell {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var state: State = .idle {
            didSet { self.setNeedUpdate() }
        }
        var background: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var content: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var leading: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var leadingSize: Float = 0 {
            didSet { self.setNeedForceUpdate() }
        }
        var trailing: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var trailingSize: Float = 0 {
            didSet { self.setNeedForceUpdate() }
        }

        init() {
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.background?.frame = bounds
            switch self.state {
            case .idle:
                self.content?.frame = bounds
            case .leading(let progress):
                if let leading = self.leading {
                    let contentBeginFrame = bounds
                    let contentEndedFrame = RectFloat(
                        x: bounds.origin.x + self.leadingSize,
                        y: bounds.origin.y,
                        width: bounds.size.width,
                        height: bounds.size.height
                    )
                    let leadingBeginFrame = RectFloat(
                        x: bounds.origin.x - self.leadingSize,
                        y: bounds.origin.y,
                        width: self.leadingSize,
                        height: bounds.size.height
                    )
                    let leadingEndedFrame = RectFloat(
                        x: bounds.origin.x,
                        y: bounds.origin.y,
                        width: self.leadingSize,
                        height: bounds.size.height
                    )
                    self.content?.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress.value)
                    leading.frame = leadingBeginFrame.lerp(leadingEndedFrame, progress: progress.value)
                } else {
                    self.content?.frame = bounds
                }
            case .trailing(let progress):
                if let trailing = self.trailing {
                    let contentBeginFrame = bounds
                    let contentEndedFrame = RectFloat(
                        x: bounds.origin.x - self.trailingSize,
                        y: bounds.origin.y,
                        width: bounds.size.width,
                        height: bounds.size.height
                    )
                    let trailingBeginFrame = RectFloat(
                        x: bounds.origin.x + bounds.size.width,
                        y: bounds.origin.y,
                        width: self.trailingSize,
                        height: bounds.size.height
                    )
                    let trailingEndedFrame = RectFloat(
                        x: (bounds.origin.x + bounds.size.width) - self.trailingSize,
                        y: bounds.origin.y,
                        width: self.trailingSize,
                        height: bounds.size.height
                    )
                    self.content?.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress.value)
                    trailing.frame = trailingBeginFrame.lerp(trailingEndedFrame, progress: progress.value)
                } else {
                    self.content?.frame = bounds
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            guard let content = self.content else { return .zero }
            let contentSize = content.size(available: available)
            switch self.state {
            case .idle:
                break
            case .leading:
                if let leading = self.leading {
                    let leadingSize = leading.size(available: SizeFloat(width: self.leadingSize, height: contentSize.height))
                    return Size(width: available.width, height: max(contentSize.height, leadingSize.height))
                }
            case .trailing:
                if let trailing = self.trailing {
                    let trailingSize = trailing.size(available: SizeFloat(width: self.trailingSize, height: contentSize.height))
                    return Size(width: available.width, height: max(contentSize.height, trailingSize.height))
                }
            }
            return Size(width: available.width, height: contentSize.height)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
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
        case leading(progress: PercentFloat)
        case trailing(progress: PercentFloat)
        
    }
    
}
