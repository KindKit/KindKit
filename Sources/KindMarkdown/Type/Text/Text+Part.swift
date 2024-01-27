//
//  KindKit
//

import Foundation

public extension Text {
    
    indirect enum Part : Equatable {
        
        case plain(Text.Part.Plain)
        case link(Text.Part.Link)
        
    }
    
}

public extension Text.Part {
    
    @inlinable
    static func plain(
        options: Text.Options = [],
        text: String
    ) -> Self {
        return .plain(.init(options: options, text: text))
    }
    
    @inlinable
    static func link(
        text: Text,
        url: URL?
    ) -> Self {
        return .link(.init(text: text, url: url))
    }
    
}
