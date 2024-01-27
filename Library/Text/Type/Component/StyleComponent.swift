//
//  KindKit
//

import KindString

public struct StyleComponent : Component {
    
    public let part: Text.Part
    
    public init(
        string: String,
        options: Options
    ) {
        self.part = .init(string, options: options)
    }
    
    public init(
        @KindString.Builder builder: () -> String,
        options: Options
    ) {
        self.part = .init(builder(), options: options)
    }
    
}
