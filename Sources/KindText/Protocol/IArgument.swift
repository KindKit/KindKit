//
//  KindKit
//

import KindGraphics
import KindStringFormat

public protocol IArgument : KindStringFormat.IArgument {
    
    var options: Text.Options { get }
    
}

public extension IArgument {
    
    func text(_ specifier: Specifier) -> Text {
        return .init(self.string(specifier), options: self.options)
    }
    
}
