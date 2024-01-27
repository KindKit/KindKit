//
//  KindKit
//

@resultBuilder
public struct SequenceBuilder {
    
    public static func buildExpression(_ component: ILayout) -> ILayout {
        return component
    }
    
    public static func buildExpression< ItemType : IItem >(_ component: ItemType) -> ILayout {
        return ItemLayout(component)
    }
    
    public static func buildOptional(_ component: [ILayout]?) -> [ILayout] {
        return component ?? []
    }
    
    public static func buildLimitedAvailability(_ component: [ILayout]) -> [ILayout] {
        return component
    }
    
    public static func buildEither(first component: [ILayout]) -> [ILayout] {
        return component
    }
    
    public static func buildEither(second component: [ILayout]) -> [ILayout] {
        return component
    }
    
    public static func buildBlock(_ components: ILayout...) -> [ILayout] {
        return .init(components)
    }
    
}
