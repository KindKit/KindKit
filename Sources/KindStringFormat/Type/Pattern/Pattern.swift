//
//  KindKit
//

import KindStringScanner

enum Pattern : Equatable {

    case ieee_1003(IEEE_1003)
    
}

extension Pattern {
    
    init?(_ string: String) {
        let pattern = KindStringScanner.Pattern(Pattern.IEEE_1003.pattern)
        guard let match = try? pattern.match(string) else { return nil }
        self.init(match)
    }
    
    init?(_ match: KindStringScanner.Pattern.Output) {
        if let specifier = IEEE_1003(match) {
            self = .ieee_1003(specifier)
        } else {
            return nil
        }
    }
    
    @KindStringScanner.ComponentsBuilder
    static func patterns() -> [KindStringScanner.IComponent] {
        SkipToComponent([ "%" ])
        OptionalComponent(
            GroupComponent(Self.pattern)
        )
    }
    
    @KindStringScanner.ComponentsBuilder
    static func pattern() -> [KindStringScanner.IComponent] {
        CheckExtComponent([
            "%"
        ], { match in
            switch match {
            case "%": IEEE_1003.pattern()
            default: []
            }
        })
    }
    
}
