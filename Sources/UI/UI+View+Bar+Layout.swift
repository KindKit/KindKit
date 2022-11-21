//
//  KindKit
//

import Foundation

extension UI.View.Bar {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var placement: UI.View.Bar.Placement {
            didSet { self.setNeedForceUpdate() }
        }
        var size: Float? {
            didSet { self.setNeedForceUpdate() }
        }
        var safeArea: InsetFloat = .zero {
            didSet { self.setNeedForceUpdate() }
        }
        var background: UI.Layout.Item {
            didSet { self.setNeedForceUpdate(item: self.background) }
        }
        var content: UI.Layout.Item {
            didSet { self.setNeedForceUpdate(item: self.content) }
        }
        var separator: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.separator) }
        }
        
        init(
            placement: UI.View.Bar.Placement,
            background: IUIView,
            content: IUIView
        ) {
            self.placement = placement
            self.background = UI.Layout.Item(background)
            self.content = UI.Layout.Item(content)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let safeBounds = bounds.inset(self.safeArea)
            switch self.placement {
            case .top:
                let separatorHeight: Float
                if let separator = self.separator {
                    let separatorSize = separator.size(available: SizeFloat(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separator.frame = RectFloat(
                        bottomLeft: safeBounds.bottomLeft,
                        size: separatorSize
                    )
                    separatorHeight = separatorSize.height
                } else {
                    separatorHeight = 0
                }
                let contentHeight: Float
                if let size = self.size {
                    contentHeight = size
                } else {
                    let contentSize = self.content.size(available: SizeFloat(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                self.content.frame = RectFloat(
                    bottom: safeBounds.bottom - PointFloat(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.background.frame = RectFloat(
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
                let separatorHeight: Float
                if let separator = self.separator {
                    let separatorSize = separator.size(available: SizeFloat(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separator.frame = RectFloat(
                        topLeft: safeBounds.topLeft,
                        size: separatorSize
                    )
                    separatorHeight = separatorSize.height
                } else {
                    separatorHeight = 0
                }
                let contentHeight: Float
                if let size = self.size {
                    contentHeight = size
                } else {
                    let contentSize = self.content.size(available: SizeFloat(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                self.content.frame = RectFloat(
                    top: safeBounds.top + PointFloat(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.background.frame = RectFloat(
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
        
        func size(available: SizeFloat) -> SizeFloat {
            var height: Float
            if let size = self.size {
                height = size
            } else {
                let contentSize = self.content.size(available: SizeFloat(
                    width: available.width - self.safeArea.horizontal,
                    height: .infinity
                ))
                height = contentSize.height
            }
            if let separator = self.separator {
                let separatorSize = separator.size(available: SizeFloat(
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
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = [
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

