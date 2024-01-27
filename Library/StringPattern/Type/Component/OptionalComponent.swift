//
//  KindKit
//

import KindStringScanner

public struct OptionalComponent< Component : KindStringPattern.Component > : KindStringPattern.Component {
    
    private let _content: Component
    
    public init(_ content: Component) {
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
