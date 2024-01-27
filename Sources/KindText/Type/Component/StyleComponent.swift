//
//  KindKit
//

import KindString

public struct StyleComponent : IComponent {
    
    public let text: Text
    
    public init(
        string: String,
        options: Text.Options
    ) {
        self.text = .init(string, options: options)
    }
    
    public init(
        @KindString.Builder builder: () -> String,
        options: Text.Options
    ) {
        self.text = .init(builder(), options: options)
    }
    
}
