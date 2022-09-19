//
//  KindKit
//

import Foundation

extension UI.View.Bar {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var placement: UI.View.Bar.Placement {
            didSet { self.setNeedForceUpdate() }
        }
        var size: Float? = nil {
            didSet { self.setNeedForceUpdate() }
        }
        var safeArea: InsetFloat = .zero {
            didSet { self.setNeedForceUpdate() }
        }
        var backgroundItem: UI.Layout.Item {
            didSet { self.setNeedForceUpdate(item: self.backgroundItem) }
        }
        var contentItem: UI.Layout.Item {
            didSet { self.setNeedForceUpdate(item: self.contentItem) }
        }
        var separatorItem: UI.Layout.Item? = nil {
            didSet { self.setNeedForceUpdate(item: self.separatorItem) }
        }
        
        init(
            placement: UI.View.Bar.Placement,
            backgroundView: IUIView,
            contentView: IUIView
        ) {
            self.placement = placement
            self.backgroundItem = UI.Layout.Item(backgroundView)
            self.contentItem = UI.Layout.Item(contentView)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let safeBounds = bounds.inset(self.safeArea)
            switch self.placement {
            case .top:
                let separatorHeight: Float
                if let separatorItem = self.separatorItem {
                    let separatorSize = separatorItem.size(available: SizeFloat(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separatorItem.frame = RectFloat(
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
                    let contentSize = self.contentItem.size(available: SizeFloat(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                self.contentItem.frame = RectFloat(
                    bottom: safeBounds.bottom - PointFloat(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.backgroundItem.frame = RectFloat(
                    topLeft: bounds.topLeft,
                    bottomRight: contentItem.frame.bottomRight
                )
                return Size(
                    width: bounds.width,
                    height: separatorHeight + contentHeight + self.safeArea.vertical
                )
            case .bottom:
                let separatorHeight: Float
                if let separatorItem = self.separatorItem {
                    let separatorSize = separatorItem.size(available: SizeFloat(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separatorItem.frame = RectFloat(
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
                    let contentSize = self.contentItem.size(available: SizeFloat(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                self.contentItem.frame = RectFloat(
                    top: safeBounds.top + PointFloat(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.backgroundItem.frame = RectFloat(
                    topLeft: contentItem.frame.topLeft,
                    bottomRight: bounds.bottomRight
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
                let contentSize = self.contentItem.size(available: SizeFloat(
                    width: available.width - self.safeArea.horizontal,
                    height: .infinity
                ))
                height = contentSize.height
            }
            if let separatorItem = self.separatorItem {
                let separatorSize = separatorItem.size(available: SizeFloat(
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
                self.backgroundItem
            ]
            if let separatorItem = self.separatorItem {
                items.append(separatorItem)
            }
            items.append(self.contentItem)
            return items
        }
        
    }
    
}

