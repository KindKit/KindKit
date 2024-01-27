//
//  KindKit
//

import KindGeometry

enum StackHelper {
}

extension StackHelper {
    
    static func hSize(
        purpose: SizeRequest,
        spacing: Coordinate,
        content: SequenceCache
    ) -> Size {
        return Self.hSize(
            purpose: purpose,
            spacing: spacing,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func hSize(
        purpose: SizeRequest,
        spacing: Coordinate,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        guard contentCount > 0 else {
            return .zero
        }
        var maximum = Coordinate.zero
        var accumulate = Coordinate.zero
        for index in 0 ..< contentCount {
            let contentPurpose = purpose.decrease(width: accumulate)
            let size = contentSize(contentPurpose, index)
            if size.width > 0 {
                maximum = max(maximum, size.height)
                accumulate += size.width + spacing
            }
        }
        return .init(
            width: accumulate > 0 ? accumulate - spacing : accumulate,
            height: purpose.available.height.validated(default: maximum)
        )
    }
    
    static func hFrames(
        purpose: ArrangeRequest,
        spacing: Coordinate,
        alignment: VAlignment,
        content: SequenceCache
    ) -> SequenceHelper.Frames {
        return Self.hFrames(
            purpose: purpose,
            spacing: spacing,
            alignment: alignment,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func hFrames(
        purpose: ArrangeRequest,
        spacing: Coordinate,
        alignment: VAlignment,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> SequenceHelper.Frames {
        guard contentCount > 0 else {
            return .init(
                final: .init(
                    origin: purpose.container.origin,
                    size: .zero
                ),
                content: []
            )
        }
        let sizePurpose = SizeRequest(purpose)
        var maximum = Coordinate.zero
        var accumulate = Coordinate.zero
        var frames: [Rect] = .kk_make(reserve: contentCount)
        for index in 0 ..< contentCount {
            let contentPurpose = sizePurpose.decrease(width: accumulate)
            let size = contentSize(contentPurpose, index)
            let origin = Point(
                x: purpose.container.x + accumulate,
                y: purpose.container.y
            )
            if size.width > 0 {
                maximum = max(maximum, size.height)
                accumulate += size.width + spacing
            }
            frames.append(.init(
                origin: origin,
                size: size
            ))
        }
        return .init(
            final: .init(
                origin: purpose.container.origin,
                size: .init(
                    width: accumulate > 0 ? accumulate - spacing : accumulate,
                    height: purpose.available.height.validated(default: maximum)
                )
            ),
            content: frames,
            alignment: alignment
        )
    }
    
}

extension StackHelper {
    
    static func vSize(
        purpose: SizeRequest,
        spacing: Coordinate,
        content: SequenceCache
    ) -> Size {
        return Self.vSize(
            purpose: purpose,
            spacing: spacing,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vSize(
        purpose: SizeRequest,
        spacing: Coordinate,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        guard contentCount > 0 else {
            return .zero
        }
        var maximum = Coordinate.zero
        var accumulate = Coordinate.zero
        for index in 0 ..< contentCount {
            let contentPurpose = purpose.decrease(height: accumulate)
            let size = contentSize(contentPurpose, index)
            if size.height > 0 {
                maximum = max(maximum, size.width)
                accumulate += size.height + spacing
            }
        }
        return .init(
            width: purpose.available.width.validated(default: maximum),
            height: accumulate > 0 ? accumulate - spacing : accumulate
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        spacing: Coordinate,
        alignment: HAlignment,
        content: SequenceCache
    ) -> SequenceHelper.Frames {
        return Self.vFrames(
            purpose: purpose,
            spacing: spacing,
            alignment: alignment,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        spacing: Coordinate,
        alignment: HAlignment,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> SequenceHelper.Frames {
        guard contentCount > 0 else {
            return .init(
                final: .init(
                    origin: purpose.container.origin,
                    size: .zero
                ),
                content: []
            )
        }
        let sizePurpose = SizeRequest(purpose)
        var maximum = Coordinate.zero
        var accumulate = Coordinate.zero
        var frames: [Rect] = .kk_make(reserve: contentCount)
        for index in 0 ..< contentCount {
            let contentPurpose = sizePurpose.decrease(height: accumulate)
            let size = contentSize(contentPurpose, index)
            let origin = Point(
                x: purpose.container.x,
                y: purpose.container.y + accumulate
            )
            if size.height > 0 {
                maximum = max(maximum, size.width)
                accumulate += size.height + spacing
            }
            frames.append(.init(
                origin: origin,
                size: size
            ))
        }
        return .init(
            final: .init(
                origin: purpose.container.origin,
                size: .init(
                    width: purpose.available.width.validated(default: maximum),
                    height: accumulate > 0 ? accumulate - spacing : accumulate
                )
            ),
            content: frames,
            alignment: alignment
        )
    }
    
}
