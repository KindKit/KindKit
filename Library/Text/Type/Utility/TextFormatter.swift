//
//  KindKit
//

import KindStringFormat

public struct TextFormatter : KindStringFormat.Formatter {
    
    private let _options: Options
    
    public init(
        options: Options
    ) {
        self._options = options
    }

    public func argument(_ argument: any Argument, specifier: Specifier) -> Text.Part {
        return argument.part(specifier)
    }
    
    public func placeholder(_ placeholder: String) -> Text.Part {
        return .init(placeholder, options: self._options)
    }
    
    public func undefined() -> Text.Part {
        return .init()
    }
    
}
