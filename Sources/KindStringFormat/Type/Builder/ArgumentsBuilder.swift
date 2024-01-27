//
//  KindKit
//

@resultBuilder
public struct ArgumentsBuilder {
    
    public static func buildExpression< ExpressionType : IArgument >(_ expression: ExpressionType) -> [IArgument] {
        return [ expression ]
    }
    
    public static func buildEither(first component: [IArgument]) -> [IArgument] {
        return component
    }
    
    public static func buildEither(second component: [IArgument]) -> [IArgument] {
        return component
    }
    
    public static func buildLimitedAvailability(_ component: [IArgument]) -> [IArgument] {
        return component
    }
    
    public static func buildOptional(_ component: [IArgument]?) -> [IArgument] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [IArgument]...) -> [IArgument] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[IArgument]]) -> [IArgument] {
        return .init(components.joined())
    }
    
}
