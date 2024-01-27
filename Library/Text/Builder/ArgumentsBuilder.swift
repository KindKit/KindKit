//
//  KindKit
//

@resultBuilder
public struct ArgumentsBuilder {
    
    public static func buildExpression< Expression : Argument >(_ expression: Expression) -> [any Argument] {
        return [ expression ]
    }
    
    public static func buildEither(first component: [any Argument]) -> [any Argument] {
        return component
    }
    
    public static func buildEither(second component: [any Argument]) -> [any Argument] {
        return component
    }
    
    public static func buildLimitedAvailability(_ component: [any Argument]) -> [any Argument] {
        return component
    }
    
    public static func buildOptional(_ component: [any Argument]?) -> [any Argument] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [any Argument]...) -> [any Argument] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[any Argument]]) -> [any Argument] {
        return .init(components.joined())
    }
    
}
