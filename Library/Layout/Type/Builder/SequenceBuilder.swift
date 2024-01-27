//
//  KindKit
//

@resultBuilder
public struct SequenceBuilder {
    
    public static func buildExpression(_ component: any Layout) -> any Layout {
        return component
    }
    
    public static func buildExpression< Item : KindLayout.Item >(_ component: Item) -> any Layout {
        return ItemLayout(component)
    }
    
    public static func buildOptional(_ component: [any Layout]?) -> [any Layout] {
        return component ?? []
    }
    
    public static func buildLimitedAvailability(_ component: [any Layout]) -> [any Layout] {
        return component
    }
    
    public static func buildEither(first component: [any Layout]) -> [any Layout] {
        return component
    }
    
    public static func buildEither(second component: [any Layout]) -> [any Layout] {
        return component
    }
    
    public static func buildBlock(_ components: any Layout...) -> [any Layout] {
        return .init(components)
    }
    
}
