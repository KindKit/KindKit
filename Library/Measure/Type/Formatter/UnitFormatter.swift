//
//  KindKit
//

import Foundation
import KindLocalize
import KindMonadicMacro

@Monadic
public final class UnitFormatter< Unit : KindMeasure.Unit > : FormatterTrait {
    
    @MonadicField
    public var finder: (any KindLocalize.Finder)? {
        set {
            if let finder = newValue {
                self._finder.override = .init(finder)
            } else {
                self._finder.override = nil
            }
        }
        get { self._finder.override }
    }
    
    @MonadicField
    public var width: Width = .symbol
    
    private var _finder = KindLocalize.OverrideFinder(
        default: Unit.finder
    )
    
    public init() {
    }
    
    public func format(_ input: Unit) -> String {
        for variant in self.width.variants {
            let key = variant.key(by: input.name, in: self._finder)
            if let string = key.find {
                return string
            }
        }
        return ""
    }
    
}

extension UnitFormatter : Equatable {
    
    public static func == (lhs: UnitFormatter, rhs: UnitFormatter) -> Bool {
        return lhs === rhs
    }
    
}
