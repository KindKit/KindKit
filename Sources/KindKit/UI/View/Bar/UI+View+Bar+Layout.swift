//
//  KindKit
//

import Foundation

extension UI.View.Bar {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var placement: UI.View.Bar.Placement {
            didSet { self.setNeedUpdate() }
        }
        var size: Double? {
            didSet { self.setNeedUpdate() }
        }
        var safeArea: Inset = .zero {
            didSet { self.setNeedUpdate() }
        }
        var background: IUIView {
            didSet { self.setNeedUpdate(self.background) }
        }
        var content: IUIView {
            didSet { self.setNeedUpdate(self.content) }
        }
        var separator: IUIView? {
            didSet { self.setNeedUpdate(self.separator) }
        }
        
        init(
            placement: UI.View.Bar.Placement,
            background: IUIView,
            content: IUIView
        ) {
            self.placement = placement
            self.background = background
            self.content = content
        }
        
        func layout(bounds: Rect) -> Size {
            let safeBounds = bounds.inset(self.safeArea)
            switch self.placement {
            case .top:
                let separatorHeight: Double
                if let separator = self.separator {
                    let separatorSize = separator.size(available: Size(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separator.frame = Rect(
                        bottomLeft: safeBounds.bottomLeft,
                        size: separatorSize
                    )
                    separatorHeight = separatorSize.height
                } else {
                    separatorHeight = 0
                }
                let contentHeight: Double
                if let size = self.size {
                    contentHeight = size
                } else {
                    let contentSize = self.content.size(available: Size(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                self.content.frame = Rect(
                    bottom: safeBounds.bottom - Point(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.background.frame = Rect(
                    x: bounds.x,
                    y: bounds.y,
                    width: bounds.width,
                    height: bounds.height - separatorHeight
                )
                return Size(
                    width: bounds.width,
                    height: separatorHeight + contentHeight + self.safeArea.vertical
                )
            case .bottom:
                let separatorHeight: Double
                if let separator = self.separator {
                    let separatorSize = separator.size(available: Size(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separator.frame = Rect(
                        topLeft: safeBounds.topLeft,
                        size: separatorSize
                    )
                    separatorHeight = separatorSize.height
                } else {
                    separatorHeight = 0
                }
                let contentHeight: Double
                if let size = self.size {
                    contentHeight = size
                } else {
                    let contentSize = self.content.size(available: Size(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                self.content.frame = Rect(
                    top: safeBounds.top + Point(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.background.frame = Rect(
                    x: bounds.x,
                    y: bounds.y + separatorHeight,
                    width: bounds.width,
                    height: bounds.height - separatorHeight
                )
                return Size(
                    width: bounds.width,
                    height: separatorHeight + contentHeight + self.safeArea.vertical
                )
            }
        }
        
        func size(available: Size) -> Size {
            var height: Double
            if let size = self.size {
                height = size
            } else {
                let contentSize = self.content.size(available: Size(
                    width: available.width - self.safeArea.horizontal,
                    height: .infinity
                ))
                height = contentSize.height
            }
            if let separator = self.separator {
                let separatorSize = separator.size(available: Size(
                    width: available.width - self.safeArea.horizontal,
                    height: .infinity
                ))
                height += separatorSize.height
            }
            return Size(
                width: available.width,
                height: height + self.safeArea.vertical
            )
        }
        
        func views(bounds: Rect) -> [IUIView] {
            var items: [IUIView] = [
                self.background
            ]
            if let separator = self.separator {
                items.append(separator)
            }
            items.append(self.content)
            return items
        }
        
    }
    
}

