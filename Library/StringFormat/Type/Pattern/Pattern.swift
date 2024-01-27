//
//  KindKit
//

import KindStringPattern

enum Pattern : Equatable {

    case ieee_1003(IEEE_1003)
    
}

extension Pattern {
    
    init?(_ string: String) {
        let pattern = KindStringPattern.Pattern(Pattern.IEEE_1003.pattern)
        guard let match = try? pattern.match(string) else { return nil }
        self.init(match)
    }
    
    init?(_ match: KindStringPattern.Pattern.Output) {
        if let specifier = IEEE_1003(match) {
            self = .ieee_1003(specifier)
        } else {
            return nil
        }
    }
    
    @KindStringPattern.ComponentsBuilder
    static func patterns() -> [KindStringPattern.Component] {
        SkipToComponent([ "%" ])
        OptionalComponent(
            GroupComponent(Self.pattern)
        )
    }
    
    @KindStringPattern.ComponentsBuilder
    static func pattern() -> [KindStringPattern.Component] {
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
