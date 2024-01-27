//
//  KindKit
//

import KindMath

enum GridHelper {
}

extension GridHelper {
    
    static func vSize(
        purpose: SizeRequest,
        columns: [GridPolicy],
        spacing: Point,
        content: SequenceCache
    ) -> Size {
        return Self.vSize(
            purpose: purpose,
            columns: columns,
            spacing: spacing,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vSize(
        purpose: SizeRequest,
        columns: [GridPolicy],
        spacing: Point,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> Size {
        guard contentCount > 0 else {
            return .zero
        }
        let widths = Self._widths(
            purpose: purpose,
            columns: columns,
            spacing: spacing,
            contentCount: contentCount,
            contentSize: contentSize
        )
        var accumulateSize = Size.zero
        var lineAccumulate = Size.zero
        var lineCount = Int.zero
        for index in 0 ..< contentCount {
            let column = index % columns.count
            let width = widths[column]
            let contentPurpose = purpose
                .override(width: width)
                .decrease(height: accumulateSize.height)
            let size = contentSize(contentPurpose, index)
            if size.isZero == false {
                lineAccumulate = .init(
                    width: lineAccumulate.width + size.width + spacing.x,
                    height: max(lineAccumulate.height, size.height)
                )
                lineCount += 1
            }
            if lineCount == columns.count {
                accumulateSize = .init(
                    width: max(accumulateSize.width, lineAccumulate.width - spacing.x),
                    height: accumulateSize.height + lineAccumulate.height + spacing.y
                )
                lineAccumulate = .zero
                lineCount = .zero
            }
        }
        if lineCount > 0 {
            accumulateSize = .init(
                width: max(accumulateSize.width, lineAccumulate.width - spacing.x),
                height: accumulateSize.height + lineAccumulate.height
            )
        } else if accumulateSize.height > 0 {
            accumulateSize.height -= spacing.y
        }
        return accumulateSize
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        columns: [GridPolicy],
        hAlignment: HAlignment,
        vAlignment: VAlignment,
        spacing: Point,
        content: SequenceCache
    ) -> SequenceHelper.RowsFrames {
        return Self.vFrames(
            purpose: purpose,
            columns: columns,
            hAlignment: hAlignment,
            vAlignment: vAlignment,
            spacing: spacing,
            contentCount: content.count(),
            contentSize: { purpose, index in
                return content.size(of: purpose, at: index)
            }
        )
    }
    
    static func vFrames(
        purpose: ArrangeRequest,
        columns: [GridPolicy],
        hAlignment: HAlignment,
        vAlignment: VAlignment,
        spacing: Point,
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
        let widths = Self._widths(
            purpose: sizePurpose,
            columns: columns,
            spacing: spacing,
            contentCount: contentCount,
            contentSize: contentSize
        )
        var accumulateSize = Size.zero
        var lineBounds = Rect(
            origin: purpose.container.origin,
            size: .zero
        )
        var rows: [SequenceHelper.Frames] = []
        var frames: [Rect] = .kk_make(reserve: contentCount)
        for index in 0 ..< contentCount {
            let column = index % columns.count
            let width = widths[column]
            let contentPurpose = sizePurpose
                .override(width: width)
                .decrease(height: accumulateSize.height)
            let size = contentSize(contentPurpose, index)
            let frame: Rect
            if size.isZero == false {
                frame = .init(
                    topLeft: lineBounds.topRight,
                    size: size
                )
                lineBounds.size = .init(
                    width: lineBounds.width + size.width + spacing.x,
                    height: max(lineBounds.height, size.height)
                )
            } else {
                frame = .init(
                    origin: lineBounds.topRight,
                    size: size
                )
            }
            frames.append(frame)
            if frames.count == columns.count {
                accumulateSize = .init(
                    width: max(accumulateSize.width, lineBounds.width - spacing.x),
                    height: accumulateSize.height + lineBounds.height + spacing.y
                )
                rows.append(.init(
                    final: .init(
                        origin: lineBounds.origin,
                        size: .init(
                            width: lineBounds.width - spacing.x,
                            height: lineBounds.height
                        )
                    ),
                    content: frames,
                    alignment: vAlignment
                ))
                frames.removeAll(keepingCapacity: true)
                lineBounds = .init(
                    x: purpose.container.x,
                    y: lineBounds.maxY + spacing.y,
                    size: .zero
                )
            }
        }
        if frames.count > 0 {
            accumulateSize = .init(
                width: max(accumulateSize.width, lineBounds.width - spacing.x),
                height: accumulateSize.height + lineBounds.height
            )
            rows.append(.init(
                final: .init(
                    origin: lineBounds.origin,
                    size: .init(
                        width: lineBounds.width - spacing.x,
                        height: lineBounds.height
                    )
                ),
                content: frames,
                alignment: vAlignment
            ))
        } else if accumulateSize.height > 0 {
            accumulateSize.height -= spacing.y
        }
        return .init(
            final: .init(
                origin: purpose.container.origin,
                size: .init(
                    width: purpose.available.width.normalized(accumulateSize.width),
                    height: accumulateSize.height
                )
            ),
            content: rows,
            alignment: hAlignment
        )
    }
    
}

fileprivate extension GridHelper {
    
    static func _widths(
        purpose: SizeRequest,
        columns: [GridPolicy],
        spacing: Point,
        contentCount: Int,
        contentSize: (SizeRequest, Int) -> Size
    ) -> [Double] {
        let available = purpose.available.width.normalized(purpose.container.width)
        guard columns.count >= 2 else {
            return .init(
                repeating: available,
                count: columns.count
            )
        }
        var fitColumns = 0
        var autoColumns = 0
        for column in columns {
            switch column {
            case .auto: autoColumns += 1
            case .fit: fitColumns += 1
            }
        }
        guard fitColumns > 0 else {
            let spacing = spacing.x * Double(columns.count - 1)
            let width = (available - spacing) / Double(columns.count)
            return .init(
                repeating: width,
                count: columns.count
            )
        }
        var accumulator: [Double] = .init(
            repeating: 0,
            count: columns.count
        )
        for index in 0 ..< contentCount {
            let columnIndex = index % columns.count
            let column = columns[columnIndex]
            switch column {
            case .auto:
                break
            case .fit:
                let size = contentSize(purpose, index)
                accumulator[columnIndex] = max(accumulator[columnIndex], size.width)
            }
        }
        let fitSpacing = spacing.x * Double(fitColumns)
        let fitWidth = accumulator.reduce(0, { $0 + $1 })
        let leftWidth = available - (fitWidth + fitSpacing)
        let autoSpacing = spacing.x * Double(autoColumns - 1)
        let autoWidth = (leftWidth - autoSpacing) / Double(autoColumns)
        return .init(unsafeUninitializedCapacity: columns.count, initializingWith: { buffer, count in
            for index in columns.indices {
                let column = columns[index]
                switch column {
                case .auto: buffer[index] = autoWidth
                case .fit: buffer[index] = accumulator[index]
                }
            }
            count = columns.count
        })
    }
    
}
