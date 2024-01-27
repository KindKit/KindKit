//
//  KindKit
//

import KindStringFormat

public struct TextFormatter : KindStringFormat.IFormatter {
    
    private let _options: Text.Options
    
    public init(
        options: Text.Options
    ) {
        self._options = options
    }

    public func argument(_ argument: IArgument, specifier: Specifier) -> Text {
        return argument.text(specifier)
    }
    
    public func placeholder(_ placeholder: String) -> Text {
        return .init(placeholder, options: self._options)
    }
    
    public func undefined() -> Text {
        return .init()
    }
    
}
