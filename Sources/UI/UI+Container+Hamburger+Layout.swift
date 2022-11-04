//
//  KindKit
//

import Foundation

extension UI.Container.Hamburger {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var state: State {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: UI.Layout.Item {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var leading: UI.Layout.Item? {
            didSet {
                guard self.leading != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var leadingSize: Float {
            didSet {
                guard self.leadingSize != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var trailing: UI.Layout.Item? {
            didSet {
                guard self.trailing != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var trailingSize: Float {
            didSet {
                guard self.trailingSize != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            state: State = .idle,
            content: UI.Layout.Item,
            leading: UI.Layout.Item?,
            leadingSize: Float,
            trailing: UI.Layout.Item?,
            trailingSize: Float
        ) {
            self.state = state
            self.content = content
            self.leading = leading
            self.leadingSize = leadingSize
            self.trailing = trailing
            self.trailingSize = trailingSize
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
                    self.content.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress)
                    leading.frame = leadingBeginFrame.lerp(leadingEndedFrame, progress: progress)
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
                    self.content.frame = contentBeginFrame.lerp(contentEndedFrame, progress: progress)
                    trailing.frame = trailingBeginFrame.lerp(trailingEndedFrame, progress: progress)
                } else {
                    self.content.frame = bounds
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
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
