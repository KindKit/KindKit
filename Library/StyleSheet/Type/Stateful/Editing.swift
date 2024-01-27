//
//  KindKit
//

import KindMonadicMacro

@Monadic
public struct Editing< Content : ResolveTrait > : ResolveTrait, EditingTrait {
    
    @MonadicField
    public let normal: Content

    @MonadicField
    public let editing: Content
    
    public init(
        normal: Content,
        editing: Content
    ) {
        self.normal = normal
        self.editing = editing
    }
    
    public func resolve(_ states: States) -> Content.Resolve {
        if states.contains(.editing) == true {
            return self.editing.resolve(states)
        }
        return self.normal.resolve(states)
    }

}

extension Editing : DisabledTrait where Content : DisabledTrait {
}

extension Editing : HighlightedTrait where Content : HighlightedTrait {
}

extension Editing : SelectedTrait where Content : SelectedTrait {
}

extension Editing : MergeTrait where Content : MergeTrait {
    
    public func merge(_ other: Self) -> Self {
        return .init(
            normal: self.normal.merge(other.normal),
            editing: self.editing.merge(other.editing)
        )
    }
    
}
