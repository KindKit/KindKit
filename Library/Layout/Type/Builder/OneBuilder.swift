//
//  KindKit
//

@resultBuilder
public struct OneBuilder {
    
    public static func buildExpression< Layout : KindLayout.Layout >(_ component: Layout) -> Layout {
        return component
    }
    
    public static func buildExpression< Item : KindLayout.Item >(_ component: Item) -> ItemLayout< Item > {
        return ItemLayout(component)
    }
    
    public static func buildOptional< Layout : KindLayout.Layout >(_ component: Layout?) -> OptionalLayout< Layout > {
        guard let component = component else { return .init() }
        return .init(component)
    }
    
    public static func buildLimitedAvailability< Layout : KindLayout.Layout >(_ component: Layout) -> Layout {
        return component
    }
    
    public static func buildEither< Layout : KindLayout.Layout >(first component: Layout) -> Layout {
        return component
    }
    
    public static func buildEither< Layout : KindLayout.Layout >(second component: Layout) -> Layout {
        return component
    }
    
    public static func buildPartialBlock< Layout : KindLayout.Layout >(first component: Layout) -> Layout {
        return component
    }
    
    public static func buildPartialBlock< Accumulated : Layout, Next : Layout >(accumulated: Accumulated, next: Next) -> TupleLayout< Accumulated, Next > {
        return .init(accumulated, next)
    }
    
}
