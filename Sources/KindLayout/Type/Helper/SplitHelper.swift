//
//  KindKit
//

import KindMath

enum SplitHelper {
}

extension SplitHelper {
    
    static func hSize(
        purpose: SizeRequest,
        spacing: Double,
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
        spacing: Double,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        guard contentCount > 0 else {
            return .zero
        }
        var maximum = Double.zero
        var accumulate = Double.zero
        var contentPurpose = Self._hSizePurpose(
            of: purpose,
            spacing: spacing,
            count: contentCount
        )
        var invalidIndecies = Set< Int >()
        do {
            for index in 0 ..< contentCount {
                let size = contentSize(contentPurpose, index)
                if size.width > 0 {
                    maximum = max(maximum, size.height)
                    accumulate += size.width + spacing
                } else {
                    invalidIndecies.insert(index)
                }
            }
        }
        if invalidIndecies.count > 0 {
            maximum = Double.zero
            accumulate = Double.zero
            contentPurpose = Self._hSizePurpose(
                of: purpose,
                spacing: spacing,
                count: contentCount - invalidIndecies.count
            )
            for index in 0 ..< contentCount {
                guard invalidIndecies.contains(index) == false else { continue }
                let size = contentSize(contentPurpose, index)
                maximum = max(maximum, size.height)
                accumulate += size.width + spacing
            }
        }
        return .init(
            width: accumulate > 0 ? accumulate - spacing : accumulate,
            height: purpose.available.height.normalized(maximum)
        )
    }
    
    static func hFrames(
        purpose: ArrangeRequest,
        spacing: Double,
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
        spacing: Double,
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
        var maximum = Double.zero
        var accumulate = Double.zero
        var contentPurpose = Self._hSizePurpose(
            of: sizePurpose,
            spacing: spacing,
            count: contentCount
        )
        var frames: [Rect] = .kk_make(reserve: contentCount)
        var numberOfValid = 0
        do {
            for index in 0 ..< contentCount {
                let size = contentSize(contentPurpose, index)
                let origin = Point(
                    x: purpose.container.x + accumulate,
                    y: purpose.container.y
                )
                if size.width > 0 {
                    numberOfValid += 1
                    maximum = max(maximum, size.height)
                    accumulate += size.width + spacing
                }
                frames.append(.init(
                    origin: origin,
                    size: size
                ))
            }
        }
        if numberOfValid < contentCount {
            maximum = Double.zero
            accumulate = Double.zero
            contentPurpose = Self._hSizePurpose(
                of: sizePurpose,
                spacing: spacing,
                count: numberOfValid
            )
            for index in 0 ..< contentCount {
                let origin = Point(
                    x: purpose.container.x + accumulate,
                    y: purpose.container.y
                )
                if frames[index].width > 0 {
                    let size = contentSize(contentPurpose, index)
                    maximum = max(maximum, size.height)
                    accumulate += size.width + spacing
                    frames[index] = .init(
                        origin: origin,
                        size: size
                    )
                } else {
                    frames[index].origin = origin
                }
            }
        }
        return .init(
            final: .init(
                origin: purpose.container.origin,
                size: .init(
                    width: accumulate > 0 ? accumulate - spacing : accumulate,
                    height: purpose.available.height.normalized(maximum)
                )
            ),
            content: frames,
            alignment: alignment
        )
    }
    
}

extension SplitHelper {
    
    static func vSize(
        purpose: SizeRequest,
        spacing: Double,
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
        spacing: Double,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        guard contentCount > 0 else {
            return .zero
        }
        var maximum = Double.zero
        var accumulate = Double.zero
        var contentPurpose = Self._vSizePurpose(
            of: purpose,
            spacing: spacing,
            count: contentCount
        )
        var invalidIndecies = Set< Int >()
        do {
            for index in 0 ..< contentCount {
                let size = contentSize(contentPurpose, index)
                if size.height > 0 {
                    maximum = max(maximum, size.width)
                    accumulate += size.height + spacing
                } else {
                    invalidIndecies.insert(index)
                }
            }
        }
        if invalidIndecies.count > 0 {
            maximum = Double.zero
            accumulate = Double.zero
            contentPurpose = Self._vSizePurpose(
                of: purpose,
                spacing: spacing,
                count: contentCount - invalidIndecies.count
            )
            for index in 0 ..< contentCount {
                guard invalidIndecies.contains(index) == false else { continue }
                let size = contentSize(contentPurpose, index)
                maximum = max(maximum, size.width)
                accumulate += size.height + spacing
            }
        }
        return .init(
            width: purpose.available.width.normalized(maximum),
            height: accumulate > 0 ? accumulate - spacing : accumulate
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        spacing: Double,
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
        spacing: Double,
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
        var maximum = Double.zero
        var accumulate = Double.zero
        var contentPurpose = Self._vSizePurpose(
            of: sizePurpose,
            spacing: spacing,
            count: contentCount
        )
        var frames: [Rect] = .kk_make(reserve: contentCount)
        var numberOfValid = 0
        do {
            for index in 0 ..< contentCount {
                let size = contentSize(contentPurpose, index)
                let origin = Point(
                    x: purpose.container.x,
                    y: purpose.container.y + accumulate
                )
                if size.height > 0 {
                    numberOfValid += 1
                    maximum = max(maximum, size.width)
                    accumulate += size.height + spacing
                }
                frames.append(.init(
                    origin: origin,
                    size: size
                ))
            }
        }
        if numberOfValid < contentCount {
            maximum = Double.zero
            accumulate = Double.zero
            contentPurpose = Self._vSizePurpose(
                of: sizePurpose,
                spacing: spacing,
                count: numberOfValid
            )
            for index in 0 ..< contentCount {
                let origin = Point(
                    x: purpose.container.x,
                    y: purpose.container.y + accumulate
                )
                if frames[index].height > 0 {
                    let size = contentSize(contentPurpose, index)
                    maximum = max(maximum, size.width)
                    accumulate += size.height + spacing
                    frames[index] = .init(
                        origin: origin,
                        size: size
                    )
                } else {
                    frames[index].origin = origin
                }
            }
        }
        return .init(
            final: .init(
                origin: purpose.container.origin,
                size: .init(
                    width: purpose.available.width.normalized(maximum),
                    height: accumulate > 0 ? accumulate - spacing : accumulate
                )
            ),
            content: frames,
            alignment: alignment
        )
    }
    
}

fileprivate extension SplitHelper {
    
    @inline(__always)
    static func _hSizePurpose(of base: SizeRequest, spacing: Double, count: Int) -> SizeRequest {
        let space = Self._space(
            of: base.available.width.normalized(base.container.width),
            spacing: spacing,
            count: count
        )
        return .init(
            container: .init(
                width: space,
                height: base.container.height
            ),
            available: .init(
                width: space,
                height: base.available.height
            )
        )
    }
    
    @inline(__always)
    static func _vSizePurpose(of base: SizeRequest, spacing: Double, count: Int) -> SizeRequest {
        let space = Self._space(
            of: base.available.height.normalized(base.container.height),
            spacing: spacing,
            count: count
        )
        return .init(
            container: .init(
                width: base.container.width,
                height: space
            ),
            available: .init(
                width: base.available.width,
                height: space
            )
        )
    }
    
    @inline(__always)
    static func _space(of available: Double, spacing: Double, count: Int) -> Double {
        if count > 1 {
            return (available - (spacing * Double(count - 1))) / Double(count)
        } else if count > 0 {
            return available / Double(count)
        }
        return .zero
    }
    
}
