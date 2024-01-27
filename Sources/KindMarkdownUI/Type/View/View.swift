//
//  KindKit
//

import KindMarkdown
import KindUI
import KindMonadicMacro

@KindMonadic
public final class View : IWidgetView {
    
    public let body = CustomView()
    
    @KindMonadicProperty
    public var styleSheet: IStyleSheet {
        didSet {
            guard self.styleSheet !== oldValue else { return }
            self._reload()
        }
    }
    
    @KindMonadicProperty
    public var blocks: [KindMarkdown.Block] = [] {
        didSet {
            guard self.blocks != oldValue else { return }
            self._reload()
        }
    }
    
    @KindMonadicSignal
    public let onOpenLink = Signal< Void, URL >()
    
    private let _layout = CompositionLayout(content: CompositionLayout.NonePart())
    
    public init(
        styleSheet: IStyleSheet = .default()
    ) {
        self.styleSheet = styleSheet
        self.body.content(self._layout)
    }
    
}

private extension View {
    
    enum Segment {
        
        case code(Block.Code)
        case heading(Block.Heading)
        case list([Block.List])
        case paragraph(Block.Paragraph)
        case quote(Block.Quote)
        
    }
    
}

private extension View {
    
    func _reload() {
        var segments: [Segment] = []
        do {
            var listBuffer: [Block.List] = []
            for block in self.blocks {
                switch block {
                case .code(let block):
                    if listBuffer.isEmpty == false {
                        segments.append(.list(listBuffer))
                        listBuffer.removeAll(keepingCapacity: true)
                    }
                    segments.append(.code(block))
                case .heading(let block):
                    if listBuffer.isEmpty == false {
                        segments.append(.list(listBuffer))
                        listBuffer.removeAll(keepingCapacity: true)
                    }
                    segments.append(.heading(block))
                case .list(let block):
                    listBuffer.append(block)
                case .paragraph(let block):
                    if listBuffer.isEmpty == false {
                        segments.append(.list(listBuffer))
                        listBuffer.removeAll(keepingCapacity: true)
                    }
                    segments.append(.paragraph(block))
                case .quote(let block):
                    if listBuffer.isEmpty == false {
                        segments.append(.list(listBuffer))
                        listBuffer.removeAll(keepingCapacity: true)
                    }
                    segments.append(.quote(block))
                }
            }
            if listBuffer.isEmpty == false {
                segments.append(.list(listBuffer))
                listBuffer.removeAll(keepingCapacity: true)
            }
        }
        var entities: [ILayout] = []
        for segmentIndex in segments.indices {
            let segment = segments[segmentIndex]
            let isFirstSegment = segmentIndex == segments.startIndex
            let isLastSegment = segmentIndex == segments.endIndex - 1
            switch segment {
            case .code(let block):
                entities.append(View.Code(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            case .heading(let block):
                entities.append(View.Heading(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            case .list(let blocks):
                var elements: [ILayout] = []
                for blockIndex in blocks.indices {
                    let block = blocks[blockIndex]
                    let isFirstBlock = blockIndex == blocks.startIndex
                    let isLastBlock = blockIndex == blocks.endIndex - 1
                    elements.append(View.List.Marker(
                        isFirst: isFirstSegment == true && isFirstBlock == true,
                        isLast: isLastBlock == true && isLastBlock == true,
                        styleSheet: self.styleSheet,
                        block: block,
                        onOpenLink: self.onOpenLink
                    ))
                    elements.append(View.List.Content(
                        isFirst: isFirstSegment == true && isFirstBlock == true,
                        isLast: isLastBlock == true && isLastBlock == true,
                        styleSheet: self.styleSheet,
                        block: block,
                        onOpenLink: self.onOpenLink
                    ))
                }
                entities.append(CompositionLayout.VGridPart(
                    columns: [ .fit, .proportionately ],
                    items: elements
                ))
            case .paragraph(let block):
                entities.append(View.Paragraph(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            case .quote(let block):
                entities.append(View.Quote(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            }
        }
        self._layout.content = CompositionLayout.VStackPart(
            alignment: .fill,
            items: entities
        )
    }
    
}

public extension View {
    
    @inlinable
    @discardableResult
    func text(_ value: String) -> Self {
        self.blocks = Parser.blocks(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func text(_ value: () -> String) -> Self {
        return self.text(value())
    }

    @inlinable
    @discardableResult
    func text(_ value: (Self) -> String) -> Self {
        return self.text(value(self))
    }
    
}
