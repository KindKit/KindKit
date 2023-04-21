//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Markdown : IUIWidgetView {
        
        public var styleSheet: IUIMarkdownStyleSheet {
            didSet {
                guard self.styleSheet !== oldValue else { return }
                self._reload()
            }
        }
        public var blocks: [UI.Markdown.Block] = [] {
            didSet {
                guard self.blocks != oldValue else { return }
                self._reload()
            }
        }
        public let body: UI.View.Custom
        public let onOpenLink = Signal.Args< Void, URL >()
        
        private let _layout: UI.Layout.Composition
        
        public init(
            styleSheet: IUIMarkdownStyleSheet = .default()
        ) {
            self.styleSheet = styleSheet
            self._layout = .init(entity: .none())
            self.body = .custom(self._layout)
        }
        
    }
    
}

private extension UI.View.Markdown {
    
    enum Segment {
        
        case code(UI.Markdown.Block.Code)
        case heading(UI.Markdown.Block.Heading)
        case list([UI.Markdown.Block.List])
        case paragraph(UI.Markdown.Block.Paragraph)
        case quote(UI.Markdown.Block.Quote)
        
    }
    
}

private extension UI.View.Markdown {
    
    func _reload() {
        var segments: [Segment] = []
        do {
            var listBuffer: [UI.Markdown.Block.List] = []
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
        var entities: [IUICompositionLayoutEntity] = []
        for segmentIndex in segments.indices {
            let segment = segments[segmentIndex]
            let isFirstSegment = segmentIndex == segments.startIndex
            let isLastSegment = segmentIndex == segments.endIndex - 1
            switch segment {
            case .code(let block):
                entities.append(UI.View.Markdown.Code(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            case .heading(let block):
                entities.append(UI.View.Markdown.Heading(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            case .list(let blocks):
                var elements: [IUICompositionLayoutEntity] = []
                for blockIndex in blocks.indices {
                    let block = blocks[blockIndex]
                    let isFirstBlock = blockIndex == blocks.startIndex
                    let isLastBlock = blockIndex == blocks.endIndex - 1
                    elements.append(UI.View.Markdown.List.Marker(
                        isFirst: isFirstSegment == true && isFirstBlock == true,
                        isLast: isLastBlock == true && isLastBlock == true,
                        styleSheet: self.styleSheet,
                        block: block,
                        onOpenLink: self.onOpenLink
                    ))
                    elements.append(UI.View.Markdown.List.Content(
                        isFirst: isFirstSegment == true && isFirstBlock == true,
                        isLast: isLastBlock == true && isLastBlock == true,
                        styleSheet: self.styleSheet,
                        block: block,
                        onOpenLink: self.onOpenLink
                    ))
                }
                entities.append(UI.Layout.Composition.VGrid(
                    columns: [ .fit, .proportionately ],
                    entities: elements
                ))
            case .paragraph(let block):
                entities.append(UI.View.Markdown.Paragraph(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            case .quote(let block):
                entities.append(UI.View.Markdown.Quote(
                    isFirst: isFirstSegment,
                    isLast: isLastSegment,
                    styleSheet: self.styleSheet,
                    block: block,
                    onOpenLink: self.onOpenLink
                ))
            }
        }
        self._layout.entity = .vStack(
            alignment: .fill,
            entities: entities
        )
    }
    
}

public extension UI.View.Markdown {
    
    @inlinable
    @discardableResult
    func styleSheet(_ value: IUIMarkdownStyleSheet) -> Self {
        self.styleSheet = value
        return self
    }
    
    @inlinable
    @discardableResult
    func styleSheet(_ value: () -> IUIMarkdownStyleSheet) -> Self {
        return self.styleSheet(value())
    }

    @inlinable
    @discardableResult
    func styleSheet(_ value: (Self) -> IUIMarkdownStyleSheet) -> Self {
        return self.styleSheet(value(self))
    }
    
    @inlinable
    @discardableResult
    func text(_ value: String) -> Self {
        self.blocks = UI.Markdown.Parser.blocks(value)
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
    
    @inlinable
    @discardableResult
    func blocks(_ value: [UI.Markdown.Block]) -> Self {
        self.blocks = value
        return self
    }
    
    @inlinable
    @discardableResult
    func blocks(_ value: () -> [UI.Markdown.Block]) -> Self {
        return self.blocks(value())
    }

    @inlinable
    @discardableResult
    func blocks(_ value: (Self) -> [UI.Markdown.Block]) -> Self {
        return self.blocks(value(self))
    }
    
}

public extension UI.View.Markdown {
    
    @inlinable
    @discardableResult
    func onOpenLink(_ closure: ((URL) -> Void)?) -> Self {
        self.onOpenLink.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onOpenLink(_ closure: ((Self, URL) -> Void)?) -> Self {
        self.onOpenLink.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onOpenLink< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, URL) -> Void)?) -> Self {
        self.onOpenLink.link(sender, closure)
        return self
    }
    
}
 
public extension IUIView where Self == UI.View.Markdown {
    
    @inlinable
    static func markdown(
        styleSheet: IUIMarkdownStyleSheet = .default()
    ) -> Self {
        return .init(
            styleSheet: styleSheet
        )
    }
    
}
