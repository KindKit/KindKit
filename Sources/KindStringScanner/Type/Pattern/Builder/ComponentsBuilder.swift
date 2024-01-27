//
//  KindKit
//

@resultBuilder
public struct ComponentsBuilder {
    
    public static func buildExpression(_ expression: IComponent) -> [IComponent] {
        return [ expression ]
    }
    
    public static func buildExpression(_ expression: [IComponent]) -> [IComponent] {
        return expression
    }
    
    public static func buildEither(first component: [IComponent]) -> [IComponent] {
        return component
    }
    
    public static func buildEither(second component: [IComponent]) -> [IComponent] {
        return component
    }
    
    public static func buildLimitedAvailability(_ component: [IComponent]) -> [IComponent] {
        return component
    }
    
    public static func buildOptional(_ component: [IComponent]?) -> [IComponent] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [IComponent]...) -> [IComponent] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[IComponent]]) -> [IComponent] {
        return .init(components.joined())
    }
    
}
