//
//  KindKit
//

@resultBuilder
public struct ComponentsBuilder {
    
    public static func buildExpression< Expression : Component >(_ expression: Expression) -> [Component] {
        return [ expression ]
    }
    
    public static func buildEither(first component: [Component]) -> [Component] {
        return component
    }
    
    public static func buildEither(second component: [Component]) -> [Component] {
        return component
    }
    
    public static func buildLimitedAvailability(_ component: [Component]) -> [Component] {
        return component
    }
    
    public static func buildOptional(_ component: [Component]?) -> [Component] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [Component]...) -> [Component] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[Component]]) -> [Component] {
        return .init(components.joined())
    }
    
}
