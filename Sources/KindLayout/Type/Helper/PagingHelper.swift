//
//  KindKit
//

import KindMath

enum PagingHelper {
}

extension PagingHelper {
    
    static func hSize(
        purpose: SizeRequest,
        content: SequenceCache
    ) -> Size {
        return Self.hSize(
            purpose: purpose,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func hSize(
        purpose: SizeRequest,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        var maximum = Double.zero
        var accumulate = Double.zero
        let contentPurpose = SizeRequest(
            container: purpose.container,
            available: .init(
                width: purpose.container.width,
                height: purpose.available.height
            )
        )
        for index in 0 ..< contentCount {
            let size = contentSize(contentPurpose, index)
            if size.width > 0 {
                maximum = max(maximum, size.height)
                accumulate += max(size.width, purpose.container.width)
            }
        }
        return .init(
            width: accumulate > 0 ? accumulate : accumulate,
            height: purpose.available.height.normalized(maximum)
        )
    }
    
    static func hFrames(
        purpose: ArrangeRequest,
        content: SequenceCache
    ) -> SequenceHelper.Frames {
        return Self.hFrames(
            purpose: purpose,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func hFrames(
        purpose: ArrangeRequest,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> SequenceHelper.Frames {
        var maximum = Double.zero
        var accumulate = Double.zero
        let contentPurpose = SizeRequest(
            container: purpose.container.size,
            available: .init(
                width: purpose.container.width,
                height: purpose.available.height
            )
        )
        var frames: [Rect] = .kk_make(reserve: contentCount)
        for index in 0 ..< contentCount {
            let size = contentSize(contentPurpose, index)
            let origin = Point(
                x: purpose.container.x + accumulate,
                y: purpose.container.y
            )
            if size.width > 0 {
                maximum = max(maximum, size.height)
                accumulate += max(size.width, purpose.container.width)
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
                    width: accumulate > 0 ? accumulate : accumulate,
                    height: purpose.available.height.normalized(maximum)
                )
            ),
            content: frames
        )
    }
    
}

extension PagingHelper {
    
    static func vSize(
        purpose: SizeRequest,
        content: SequenceCache
    ) -> Size {
        return Self.vSize(
            purpose: purpose,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vSize(
        purpose: SizeRequest,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        var maximum = Double.zero
        var accumulate = Double.zero
        let contentPurpose = SizeRequest(
            container: purpose.container,
            available: .init(
                width: purpose.available.width,
                height: purpose.container.height
            )
        )
        for index in 0 ..< contentCount {
            let size = contentSize(contentPurpose, index)
            if size.height > 0 {
                maximum = max(maximum, size.width)
                accumulate += max(size.height, purpose.container.height)
            }
        }
        return .init(
            width: purpose.available.width.normalized(maximum),
            height: accumulate > 0 ? accumulate : accumulate
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        content: SequenceCache
    ) -> SequenceHelper.Frames {
        return Self.vFrames(
            purpose: purpose,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> SequenceHelper.Frames {
        var maximum = Double.zero
        var accumulate = Double.zero
        let contentPurpose = SizeRequest(
            container: purpose.container.size,
            available: .init(
                width: purpose.available.width,
                height: purpose.container.height
            )
        )
        var frames: [Rect] = .kk_make(reserve: contentCount)
        for index in 0 ..< contentCount {
            let size = contentSize(contentPurpose, index)
            let origin = Point(
                x: purpose.container.x,
                y: purpose.container.y + accumulate
            )
            if size.height > 0 {
                maximum = max(maximum, size.width)
                accumulate += max(size.height, purpose.container.height)
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
                    width: purpose.available.width.normalized(maximum),
                    height: accumulate > 0 ? accumulate : accumulate
                )
            ),
            content: frames
        )
    }
    
}
