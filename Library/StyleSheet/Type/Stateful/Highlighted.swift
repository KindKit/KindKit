//
//  KindKit
//

import KindMonadicMacro

@Monadic
public struct Highlighted< Content : ResolveTrait > : ResolveTrait, HighlightedTrait {
    
    @MonadicField
    public let normal: Content

    @MonadicField
    public let highlighted: Content
    
    public init(
        normal: Content,
        highlighted: Content
    ) {
        self.normal = normal
        self.highlighted = highlighted
    }
    
    public func resolve(_ states: States) -> Content.Resolve {
        if states.contains(.hightlighted) == true {
            return self.highlighted.resolve(states)
        }
        return self.normal.resolve(states)
    }

}

extension Highlighted : DisabledTrait where Content : DisabledTrait {
}

extension Highlighted : EditingTrait where Content : EditingTrait {
}

extension Highlighted : SelectedTrait where Content : SelectedTrait {
}

extension Highlighted : MergeTrait where Content : MergeTrait {
    
    public func merge(_ other: Self) -> Self {
        return .init(
            normal: self.normal.merge(other.normal),
            highlighted: self.highlighted.merge(other.highlighted)
        )
    }
    
}
