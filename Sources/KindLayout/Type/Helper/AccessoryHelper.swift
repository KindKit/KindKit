//
//  KindKit
//

import KindMath

enum AccessoryHelper {
    
    struct Result< UnitType > {
        
        let final: UnitType
        let leading: UnitType
        let center: UnitType
        let trailing: UnitType
        
    }
    
}

extension AccessoryHelper {
    
    static func hSize(
        purpose: SizeRequest,
        leading: (SizeRequest) -> Size,
        center: (SizeRequest) -> Size,
        trailing: (SizeRequest) -> Size,
        priority: AccessoryPriority,
        filling: Bool
    ) -> Result< Size > {
        let leadingSize: Size
        let trailingSize: Size
        switch priority {
        case .leadingTrailing:
            leadingSize = leading(purpose
                .override(width: purpose.container.width)
            )
            trailingSize = trailing(purpose
                .decrease(width: leadingSize.width)
                .max(height: leadingSize.height)
            )
        case .trailingLeading:
            trailingSize = trailing(purpose
                .override(width: purpose.container.width)
            )
            leadingSize = trailing(purpose
                .decrease(width: trailingSize.width)
                .max(height: trailingSize.height)
            )
        }
        let centerSize: Size
        if filling == true {
            centerSize = center(purpose
                .decrease(width: leadingSize.width + trailingSize.width)
                .max(height: max(leadingSize.height, trailingSize.height))
            )
        } else {
            centerSize = center(purpose
                .decrease(width: max(leadingSize.width, trailingSize.width) * 2)
                .max(height: max(leadingSize.height, trailingSize.height))
            )
        }
        return .init(
            final: .init(
                width: max(purpose.available.width.normalized(0), leadingSize.width + centerSize.width + trailingSize.width),
                height: max(leadingSize.height, centerSize.height, trailingSize.height)
            ),
            leading: leadingSize,
            center: centerSize,
            trailing: trailingSize
        )
    }
    
    static func hFrames(
        purpose: ArrangeRequest,
        leading: (SizeRequest) -> Size,
        center: (SizeRequest) -> Size,
        trailing: (SizeRequest) -> Size,
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
    
    static func vSize(
        purpose: SizeRequest,
        leading: (SizeRequest) -> Size,
        center: (SizeRequest) -> Size,
        trailing: (SizeRequest) -> Size,
        priority: AccessoryPriority,
        filling: Bool
    ) -> Result< Size > {
        let leadingSize: Size
        let trailingSize: Size
        switch priority {
        case .leadingTrailing:
            leadingSize = leading(purpose
                .override(height: purpose.container.height)
            )
            trailingSize = trailing(purpose
                .decrease(height: leadingSize.height)
                .max(width: leadingSize.width)
            )
        case .trailingLeading:
            trailingSize = trailing(purpose
                .override(height: purpose.container.height)
            )
            leadingSize = trailing(purpose
                .decrease(height: trailingSize.height)
                .max(width: trailingSize.width)
            )
        }
        let centerSize: Size
        if filling == true {
            centerSize = center(purpose
                .decrease(height: leadingSize.height + trailingSize.height)
                .max(width: max(leadingSize.width, trailingSize.width))
            )
        } else {
            centerSize = center(purpose
                .decrease(height: max(leadingSize.height, trailingSize.height) * 2)
                .max(width: max(leadingSize.width, trailingSize.width))
            )
        }
        return .init(
            final: .init(
                width: max(leadingSize.width, centerSize.width, trailingSize.width),
                height: max(purpose.available.height.normalized(0), leadingSize.height + centerSize.height + trailingSize.height)
            ),
            leading: leadingSize,
            center: centerSize,
            trailing: trailingSize
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        leading: (SizeRequest) -> Size,
        center: (SizeRequest) -> Size,
        trailing: (SizeRequest) -> Size,
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
