//
//  KindKit
//

import KindGraphics
import KindStringFormat

public protocol Argument : KindStringFormat.Argument {
    
    var options: Options { get }
    
}

public extension Argument {
    
    func part(_ specifier: Specifier) -> Text.Part {
        return .init(self.string(specifier), options: self.options)
    }
    
}
