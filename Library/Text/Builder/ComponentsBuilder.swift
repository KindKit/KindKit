//
//  KindKit
//

import KindString

@resultBuilder
public struct ComponentsBuilder {
    
    public static func buildExpression< Expression : KindText.Component >(_ expression: Expression) -> [any Component] {
        return [ expression ]
    }
    
    public static func buildExpression< Expression : KindString.Component >(_ expression: Expression) -> [any Component] {
        return [ StyleComponent(string: expression.string, options: .init()) ]
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
