//
//  KindKit
//

import KindMonadicMacro

@Monadic
public struct Selected< Content : ResolveTrait > : ResolveTrait, SelectedTrait {
    
    @MonadicField
    public let unselected: Content

    @MonadicField
    public let selected: Content
    
    public init(
        unselected: Content,
        selected: Content
    ) {
        self.unselected = unselected
        self.selected = selected
    }
    
    public func resolve(_ states: States) -> Content.Resolve {
        if states.contains(.selected) == true {
            return self.selected.resolve(states)
        }
        return self.unselected.resolve(states)
    }

}

extension Selected : DisabledTrait where Content : DisabledTrait {
}

extension Selected : EditingTrait where Content : EditingTrait {
}

extension Selected : HighlightedTrait where Content : HighlightedTrait {
}

extension Selected : MergeTrait where Content : MergeTrait {
    
    public func merge(_ other: Self) -> Self {
        return .init(
            unselected: self.unselected.merge(other.unselected),
            selected: self.selected.merge(other.selected)
        )
    }
    
}
