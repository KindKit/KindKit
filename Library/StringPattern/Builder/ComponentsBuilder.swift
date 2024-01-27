//
//  KindKit
//

@resultBuilder
public struct ComponentsBuilder {
    
    public static func buildExpression(_ expression: any Component) -> [any Component] {
        return [ expression ]
    }
    
    public static func buildExpression(_ expression: [any Component]) -> [any Component] {
        return expression
    }
    
    public static func buildEither(first component: [any Component]) -> [any Component] {
        return component
    }
    
    public static func buildEither(second component: [any Component]) -> [any Component] {
        return component
    }
    
    public static func buildLimitedAvailability(_ component: [any Component]) -> [any Component] {
        return component
    }
    
    public static func buildOptional(_ component: [any Component]?) -> [any Component] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [any Component]...) -> [any Component] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[any Component]]) -> [any Component] {
        return .init(components.joined())
    }
    
}
