//
//  KindKit
//

public struct OptionalComponent< ComponentType : IComponent > : IComponent {
    
    private let _content: ComponentType
    
    public init(_ content: ComponentType) {
        self._content = content
    }
    
    public func scan(_ scanner: Scanner, in context: Pattern.Context) throws {
        context.scope({
            try scanner.scope(flags: .restoreAfterException, {
                try self._content.scan(scanner, in: context)
            })
        })
    }
    
}
