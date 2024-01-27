//
//  KindKit
//

import KindMath

enum FlowHelper {
}

extension FlowHelper {
    
    static func vSize(
        purpose: SizeRequest,
        itemSpacing: Double,
        lineSpacing: Double,
        content: SequenceCache
    ) -> Size {
        return Self.vSize(
            purpose: purpose,
            itemSpacing: itemSpacing,
            lineSpacing: lineSpacing,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vSize(
        purpose: SizeRequest,
        itemSpacing: Double,
        lineSpacing: Double,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        guard contentCount > 0 else {
            return .zero
        }
        let available = purpose.available.width.normalized(purpose.container.width)
        var accumulateSize = Size.zero
        var lineAccumulate = Size.zero
        var lineCount = Int.zero
        for index in 0 ..< contentCount {
            let contentPurpose = purpose.decrease(
                width: lineAccumulate.width,
                height: accumulateSize.height
            )
            let size = contentSize(contentPurpose, index)
            if size.isZero == false {
                let width = lineAccumulate.width + size.width + itemSpacing
                if width > available {
                    let correction = lineCount > 0 ? -itemSpacing : 0
                    accumulateSize = .init(
                        width: max(accumulateSize.width, lineAccumulate.width - correction),
                        height: accumulateSize.height + lineSpacing + lineAccumulate.height
                    )
                    lineAccumulate = size
                    lineCount = 1
                } else {
                    lineAccumulate = .init(
                        width: width,
                        height: max(lineAccumulate.height, size.height)
                    )
                    lineCount += 1
                }
            }
        }
        if lineCount > 0 {
            accumulateSize = .init(
                width: max(accumulateSize.width, lineAccumulate.width - itemSpacing),
                height: accumulateSize.height + lineSpacing + lineAccumulate.height
            )
        }
        return .init(
            width: purpose.available.width.normalized(accumulateSize.width),
            height: accumulateSize.height > 0 ? accumulateSize.height - lineSpacing : accumulateSize.height
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        hAlignment: HAlignment,
        vAlignment: VAlignment,
        itemSpacing: Double,
        lineSpacing: Double,
        content: SequenceCache
    ) -> SequenceHelper.RowsFrames {
        return Self.vFrames(
            purpose: purpose,
            hAlignment: hAlignment,
            vAlignment: vAlignment,
            itemSpacing: itemSpacing,
            lineSpacing: lineSpacing,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        hAlignment: HAlignment,
        vAlignment: VAlignment,
        itemSpacing: Double,
        lineSpacing: Double,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> SequenceHelper.RowsFrames {
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
        let available = purpose.available.width.normalized(purpose.container.width)
        var accumulateSize = Size.zero
        var lineBounds = Rect(
            origin: purpose.container.origin,
            size: .zero
        )
        var rows: [SequenceHelper.Frames] = []
        var frames: [Rect] = .kk_make(reserve: contentCount)
        for index in 0 ..< contentCount {
            let contentPurpose = sizePurpose.decrease(
                width: lineBounds.width,
                height: accumulateSize.height
            )
            let size = contentSize(contentPurpose, index)
            let frame: Rect
            if size.isZero == false {
                let width = lineBounds.width + size.width + itemSpacing
                if width > available {
                    let correction = frames.count > 0 ? -itemSpacing : 0
                    accumulateSize = .init(
                        width: max(accumulateSize.width, lineBounds.width - correction),
                        height: accumulateSize.height + lineSpacing + lineBounds.height
                    )
                    frame = .init(
                        x: purpose.container.x,
                        y: lineBounds.maxY + lineSpacing,
                        size: size
                    )
                    rows.append(.init(
                        final: .init(
                            origin: lineBounds.origin,
                            size: .init(
                                width: lineBounds.width - itemSpacing,
                                height: lineBounds.height
                            )
                        ),
                        content: frames,
                        alignment: vAlignment
                    ))
                    frames.removeAll(keepingCapacity: true)
                    lineBounds = .init(
                        origin: frame.origin,
                        size: size
                    )
                } else {
                    let correction = frames.count > 0 ? itemSpacing : 0
                    frame = .init(
                        x: lineBounds.maxX + correction,
                        y: lineBounds.minY,
                        size: size
                    )
                    lineBounds.size = .init(
                        width: width,
                        height: max(lineBounds.height, size.height)
                    )
                }
            } else {
                frame = .init(
                    origin: lineBounds.topRight,
                    size: size
                )
            }
            frames.append(frame)
        }
        if frames.count > 0 {
            accumulateSize = .init(
                width: max(accumulateSize.width, lineBounds.width - itemSpacing),
                height: accumulateSize.height + lineSpacing + lineBounds.height
            )
            rows.append(.init(
                final: .init(
                    origin: lineBounds.origin,
                    size: .init(
                        width: lineBounds.width - itemSpacing,
                        height: lineBounds.height
                    )
                ),
                content: frames,
                alignment: vAlignment
            ))
        }
        return .init(
            final: .init(
                origin: purpose.container.origin,
                size: .init(
                    width: purpose.available.width.normalized(accumulateSize.width),
                    height: accumulateSize.height > 0 ? accumulateSize.height - lineSpacing : accumulateSize.height
                )
            ),
            content: rows,
            alignment: hAlignment
        )
    }
    
}
