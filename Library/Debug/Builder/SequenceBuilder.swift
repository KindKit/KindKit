//
//  KindKit
//

@resultBuilder
public struct SequenceBuilder {
    
    public static func buildExpression< Expression : Info >(_ expression: Expression) -> [Info] {
        return [ expression ]
    }
    
    public static func buildEither(first component: [Info]) -> [Info] {
        return component
    }
    
    public static func buildEither(second component: [Info]) -> [Info] {
        return component
    }
    
    public static func buildLimitedAvailability(_ component: [Info]) -> [Info] {
        return component
    }
    
    public static func buildOptional(_ component: [Info]?) -> [Info] {
        return component ?? []
    }
    
    public static func buildBlock(_ components: [Info]...) -> [Info] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[Info]]) -> [Info] {
        return .init(components.joined())
    }
    
}
