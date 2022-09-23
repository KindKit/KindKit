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
        var content: UI.Layout.Item {
            didSet { self.setNeedForceUpdate() }
        }
        var leading: UI.Layout.Item? = nil {
            didSet { self.setNeedForceUpdate() }
        }
        var leadingSize: Float = 0 {
            didSet { self.setNeedForceUpdate() }
        }
        var trailing: UI.Layout.Item? = nil {
            didSet { self.setNeedForceUpdate() }
        }
        var trailingSize: Float = 0 {
            didSet { self.setNeedForceUpdate() }
        }

        init(
            _ content: IUIView
        ) {
            self.content = UI.Layout.Item(content)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            switch self.state {
            case .idle:
                self.content.frame = bounds
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
                    self.content.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress.value)
                    leading.frame = leadingBeginFrame.lerp(leadingEndedFrame, progress: progress.value)
                } else {
                    self.content.frame = bounds
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
                    self.content.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress.value)
                    trailing.frame = trailingBeginFrame.lerp(trailingEndedFrame, progress: progress.value)
                } else {
                    self.content.frame = bounds
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let contentSize = self.content.size(available: available)
            switch self.state {
            case .idle: break
            case .leading:
                guard let leading = self.leading else { break }
                let leadingSize = leading.size(available: SizeFloat(width: self.leadingSize, height: contentSize.height))
                return Size(width: available.width, height: max(contentSize.height, leadingSize.height))
            case .trailing:
                guard let trailing = self.trailing else { break }
                let trailingSize = trailing.size(available: SizeFloat(width: self.trailingSize, height: contentSize.height))
                return Size(width: available.width, height: max(contentSize.height, trailingSize.height))
            }
            return Size(width: available.width, height: contentSize.height)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = [ self.content ]
            switch self.state {
            case .leading where self.leading != nil:
                items.insert(self.leading!, at: 0)
            case .trailing where self.trailing != nil:
                items.insert(self.trailing!, at: 0)
            default:
                break
            }
            return items
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
