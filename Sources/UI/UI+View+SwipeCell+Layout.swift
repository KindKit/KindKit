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
        var contentItem: UI.Layout.Item {
            didSet { self.setNeedForceUpdate() }
        }
        var leadingItem: UI.Layout.Item? = nil {
            didSet { self.setNeedForceUpdate() }
        }
        var leadingSize: Float = 0 {
            didSet { self.setNeedForceUpdate() }
        }
        var trailingItem: UI.Layout.Item? = nil {
            didSet { self.setNeedForceUpdate() }
        }
        var trailingSize: Float = 0 {
            didSet { self.setNeedForceUpdate() }
        }

        init(
            _ contentView: IUIView
        ) {
            self.contentItem = UI.Layout.Item(contentView)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            switch self.state {
            case .idle:
                self.contentItem.frame = bounds
            case .leading(let progress):
                if let leadingItem = self.leadingItem {
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
                    self.contentItem.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress.value)
                    leadingItem.frame = leadingBeginFrame.lerp(leadingEndedFrame, progress: progress.value)
                } else {
                    self.contentItem.frame = bounds
                }
            case .trailing(let progress):
                if let trailingItem = self.trailingItem {
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
                    self.contentItem.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress.value)
                    trailingItem.frame = trailingBeginFrame.lerp(trailingEndedFrame, progress: progress.value)
                } else {
                    self.contentItem.frame = bounds
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let contentSize = self.contentItem.size(available: available)
            switch self.state {
            case .idle: break
            case .leading:
                guard let leadingItem = self.leadingItem else { break }
                let leadingSize = leadingItem.size(available: SizeFloat(width: self.leadingSize, height: contentSize.height))
                return Size(width: available.width, height: max(contentSize.height, leadingSize.height))
            case .trailing:
                guard let trailingItem = self.trailingItem else { break }
                let trailingSize = trailingItem.size(available: SizeFloat(width: self.trailingSize, height: contentSize.height))
                return Size(width: available.width, height: max(contentSize.height, trailingSize.height))
            }
            return Size(width: available.width, height: contentSize.height)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = [ self.contentItem ]
            switch self.state {
            case .leading where self.leadingItem != nil:
                items.insert(self.leadingItem!, at: 0)
            case .trailing where self.trailingItem != nil:
                items.insert(self.trailingItem!, at: 0)
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
