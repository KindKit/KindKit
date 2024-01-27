//
//  KindKit
//

@resultBuilder
public struct ArgumentsBuilder {
    
    public static func buildExpression< Expression : Argument >(_ expression: Expression) -> [Argument] {
        return [ expression ]
    }
    
    public static func buildEither(first component: [Argument]) -> [Argument] {
        return component
    }
    
    public static func buildEither(second component: [Argument]) -> [Argument] {
        return component
    }
    
    public static func buildLimitedAvailability(_ component: [Argument]) -> [Argument] {
        return component
    }
    
    public static func buildOptional(_ component: [Argument]?) -> [Argument] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [Argument]...) -> [Argument] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[Argument]]) -> [Argument] {
        return .init(components.joined())
    }
    
}
