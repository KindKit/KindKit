//
//  KindKit
//

import KindMonadicMacro

@Monadic
public struct Disabled< Content : ResolveTrait > : ResolveTrait, DisabledTrait {
    
    @MonadicField
    public let enabled: Content
    
    @MonadicField
    public let disabled: Content
    
    public init(
        enabled: Content,
        disabled: Content
    ) {
        self.enabled = enabled
        self.disabled = disabled
    }
    
    public func resolve(_ states: States) -> Content.Resolve {
        if states.contains(.disabled) == true {
            return self.disabled.resolve(states)
        }
        return self.enabled.resolve(states)
    }

}

extension Disabled : EditingTrait where Content : EditingTrait {
}

extension Disabled : HighlightedTrait where Content : HighlightedTrait {
}

extension Disabled : SelectedTrait where Content : SelectedTrait {
}

extension Disabled : MergeTrait where Content : MergeTrait {
    
    public func merge(_ other: Self) -> Self {
        return .init(
            enabled: self.enabled.merge(other.enabled),
            disabled: self.disabled.merge(other.disabled)
        )
    }
    
}
