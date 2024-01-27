//
//  KindKit
//

public struct QuoteComponent : IComponent {
    
    public let string: String
    
    public init(_ mode: QuoteMode) {
        self.string = mode.string
    }
    
    public init(
        _ mode: QuoteMode,
        @Builder content: () -> String
    ) {
        let quote = mode.string
        self.string = "\(quote)\(content())\(quote)"
    }
    
}
