//
//  KindKit
//

import KindGeometry

enum AccessoryHelper {
    
    struct Result< Unit > {
        
        let final: Unit
        let leading: Unit
        let center: Unit
        let trailing: Unit
        
    }
    
}

extension AccessoryHelper.Result where Unit == Rect {
    
    init(
        alignment: HAlignment,
        final: Unit,
        leading: Unit,
        center: Unit,
        trailing: Unit
    ) {
        self.final = final
        switch alignment {
        case .left:
            self.leading = leading
            self.center = center
            self.trailing = trailing
        case .center:
            let anchor = final.midX
            self.leading = .init(
                x: anchor - (leading.width / 2),
                y: leading.y,
                size: leading.size
            )
            self.center = .init(
                x: anchor - (center.width / 2),
                y: center.y,
                size: center.size
            )
            self.trailing = .init(
                x: anchor - (trailing.width / 2),
                y: trailing.y,
                size: trailing.size
            )
        case .right:
            let anchor = final.maxX
            self.leading = .init(
                x: anchor - leading.width,
                y: leading.y,
                size: leading.size
            )
            self.center = .init(
                x: anchor - center.width,
                y: center.y,
                size: center.size
            )
            self.trailing = .init(
                x: anchor - trailing.width,
                y: trailing.y,
                size: trailing.size
            )
        }
    }
    
    init(
        alignment: VAlignment,
        final: Unit,
        leading: Unit,
        center: Unit,
        trailing: Unit
    ) {
        self.final = final
        switch alignment {
        case .top:
            self.leading = leading
            self.center = center
            self.trailing = trailing
        case .center:
            let anchor = final.midY
            self.leading = .init(
                x: leading.x,
                y: anchor - (leading.height / 2),
                size: leading.size
            )
            self.center = .init(
                x: center.x,
                y: anchor - (center.height / 2),
                size: center.size
            )
            self.trailing = .init(
                x: trailing.x,
                y: anchor - (trailing.height / 2),
                size: trailing.size
            )
        case .bottom:
            let anchor = final.maxY
            self.leading = .init(
                x: leading.x,
                y: anchor - leading.height,
                size: leading.size
            )
            self.center = .init(
                x: center.x,
                y: anchor - center.height,
                size: center.size
            )
            self.trailing = .init(
                x: trailing.x,
                y: anchor - trailing.height,
                size: trailing.size
            )
        }
    }
    
}

extension AccessoryHelper {
    
    static func hSize< Leading : Layout, Center : Layout, Trailing : Layout >(
        purpose: SizeRequest,
        leading: Leading,
        center: Center,
        trailing: Trailing,
        priority: AccessoryPriority,
        filling: Bool
    ) -> Result< Size > {
        let leadingSize: Size
        let trailingSize: Size
        switch priority {
        case .leadingTrailing:
            leadingSize = leading.sizeOf(purpose
                .override(width: purpose.container.width)
            )
            trailingSize = trailing.sizeOf(purpose
                .decrease(width: leadingSize.width)
                .max(height: leadingSize.height)
            )
        case .trailingLeading:
            trailingSize = trailing.sizeOf(purpose
                .override(width: purpose.container.width)
            )
            leadingSize = trailing.sizeOf(purpose
                .decrease(width: trailingSize.width)
                .max(height: trailingSize.height)
            )
        }
        let centerSize: Size
        if filling == true {
            centerSize = center.sizeOf(purpose
                .decrease(width: leadingSize.width + trailingSize.width)
                .max(height: max(leadingSize.height, trailingSize.height))
            )
        } else {
            centerSize = center.sizeOf(purpose
                .decrease(width: max(leadingSize.width, trailingSize.width) * 2)
                .max(height: max(leadingSize.height, trailingSize.height))
            )
        }
        let baseWidth = purpose.width
        let width: Coordinate
        if baseWidth.isInfinite == false {
            width = baseWidth - (leadingSize.width + trailingSize.width)
        } else {
            width = centerSize.width
        }
        let height: Coordinate
        if purpose.available.height.isInfinite == false {
            height = max(leadingSize.height, centerSize.height, trailingSize.height, purpose.available.height)
        } else {
            height = max(leadingSize.height, centerSize.height, trailingSize.height)
        }
        return .init(
            final: .init(
                width: leadingSize.width + width + trailingSize.width,
                height: height
            ),
            leading: leadingSize,
            center: centerSize,
            trailing: trailingSize
        )
    }
    
    static func hFrames< Leading : Layout, Center : Layout, Trailing : Layout >(
        purpose: ArrangeRequest,
        alignment: VAlignment,
        leading: Leading,
        center: Center,
        trailing: Trailing,
        priority: AccessoryPriority,
        filling: Bool
    ) -> Result< Rect > {
        let sizes = Self.hSize(
            purpose: .init(purpose),
            leading: leading,
            center: center,
            trailing: trailing,
            priority: priority,
            filling: filling
        )
        let final = Rect(
            origin: purpose.container.origin,
            size: sizes.final
        )
        let centerRect: Rect
        if filling == true {
            let valid = final.inset(.init(
                top: 0,
                left: sizes.leading.width,
                right: sizes.trailing.width,
                bottom: 0
            ))
            centerRect = .init(
                center: valid.center,
                width: sizes.final.width - (sizes.leading.width + sizes.trailing.width),
                height: sizes.center.height
            )
        } else {
            centerRect = .init(
                center: final.center,
                width: sizes.final.width - (max(sizes.leading.width, sizes.trailing.width) * 2),
                height: sizes.center.height
            )
        }
        return .init(
            alignment: alignment,
            final: final,
            leading: .init(
                left: final.left,
                size: sizes.leading
            ),
            center: centerRect,
            trailing: .init(
                right: final.right,
                size: sizes.trailing
            )
        )
    }
    
}

extension AccessoryHelper {
    
    static func vSize< Leading : Layout, Center : Layout, Trailing : Layout >(
        purpose: SizeRequest,
        leading: Leading,
        center: Center,
        trailing: Trailing,
        priority: AccessoryPriority,
        filling: Bool
    ) -> Result< Size > {
        let leadingSize: Size
        let trailingSize: Size
        switch priority {
        case .leadingTrailing:
            leadingSize = leading.sizeOf(purpose
                .override(height: purpose.container.height)
            )
            trailingSize = trailing.sizeOf(purpose
                .decrease(height: leadingSize.height)
                .max(width: leadingSize.width)
            )
        case .trailingLeading:
            trailingSize = trailing.sizeOf(purpose
                .override(height: purpose.container.height)
            )
            leadingSize = trailing.sizeOf(purpose
                .decrease(height: trailingSize.height)
                .max(width: trailingSize.width)
            )
        }
        let centerSize: Size
        if filling == true {
            centerSize = center.sizeOf(purpose
                .decrease(height: leadingSize.height + trailingSize.height)
                .max(width: max(leadingSize.width, trailingSize.width))
            )
        } else {
            centerSize = center.sizeOf(purpose
                .decrease(height: max(leadingSize.height, trailingSize.height) * 2)
                .max(width: max(leadingSize.width, trailingSize.width))
            )
        }
        let width: Coordinate
        if purpose.available.width.isInfinite == false {
            width = max(leadingSize.width, centerSize.width, trailingSize.width, purpose.available.width)
        } else {
            width = max(leadingSize.width, centerSize.width, trailingSize.width)
        }
        let baseHeight = purpose.height
        let height: Coordinate
        if baseHeight.isInfinite == false {
            height = baseHeight - (leadingSize.height + trailingSize.height)
        } else {
            height = centerSize.height
        }
        return .init(
            final: .init(
                width: width,
                height: leadingSize.height + height + trailingSize.height
            ),
            leading: leadingSize,
            center: centerSize,
            trailing: trailingSize
        )
    }
    
    static func vFrames< Leading : Layout, Center : Layout, Trailing : Layout >(
        purpose: ArrangeRequest,
        alignment: HAlignment,
        leading: Leading,
        center: Center,
        trailing: Trailing,
        priority: AccessoryPriority,
        filling: Bool
    ) -> Result< Rect > {
        let sizes = Self.vSize(
            purpose: .init(purpose),
            leading: leading,
            center: center,
            trailing: trailing,
            priority: priority,
            filling: filling
        )
        let final = Rect(
            origin: purpose.container.origin,
            size: sizes.final
        )
        let centerRect: Rect
        if filling == true {
            let valid = final.inset(.init(
                top: sizes.leading.height,
                left: 0,
                right: 0,
                bottom: sizes.trailing.height
            ))
            centerRect = .init(
                center: valid.center,
                width: sizes.center.width,
                height: sizes.final.height - (sizes.leading.height + sizes.trailing.height)
            )
        } else {
            centerRect = .init(
                center: final.center,
                width: sizes.center.width,
                height: sizes.final.height - (max(sizes.leading.height, sizes.trailing.height) * 2)
            )
        }
        return .init(
            alignment: alignment,
            final: final,
            leading: .init(
                top: final.top,
                size: sizes.leading
            ),
            center: centerRect,
            trailing: .init(
                bottom: final.bottom,
                size: sizes.trailing
            )
        )
    }
    
}
