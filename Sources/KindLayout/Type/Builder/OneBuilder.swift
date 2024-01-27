//
//  KindKit
//

@resultBuilder
public struct OneBuilder {
    
    public static func buildExpression< LayoutType : ILayout >(_ component: LayoutType) -> LayoutType {
        return component
    }
    
    public static func buildExpression< ItemType : IItem >(_ component: ItemType) -> ItemLayout< ItemType > {
        return ItemLayout(component)
    }
    
    public static func buildOptional< LayoutType : ILayout >(_ component: LayoutType?) -> OptionalLayout< LayoutType > {
        guard let component = component else { return .init() }
        return .init(component)
    }
    
    public static func buildLimitedAvailability< LayoutType : ILayout >(_ component: LayoutType) -> LayoutType {
        return component
    }
    
    public static func buildEither< LayoutType : ILayout >(first component: LayoutType) -> LayoutType {
        return component
    }
    
    public static func buildEither< LayoutType : ILayout >(second component: LayoutType) -> LayoutType {
        return component
    }
    
    public static func buildPartialBlock< LayoutType : ILayout >(first component: LayoutType) -> LayoutType {
        return component
    }
    
    public static func buildPartialBlock< AccumulatedType : ILayout, LayoutType : ILayout >(accumulated: AccumulatedType, next: LayoutType) -> TupleLayout< AccumulatedType, LayoutType > {
        return .init(accumulated, next)
    }
    
}
