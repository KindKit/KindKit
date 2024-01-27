//
//  KindKit
//

@resultBuilder
public struct ActionsBuilder {
    
    public static func buildExpression(_ component: Action) -> Action {
        return component
    }
    
    public static func buildOptional(_ component: [Action]?) -> [Action] {
        return component ?? []
    }
    
    public static func buildLimitedAvailability(_ component: [Action]) -> [Action] {
        return component
    }
    
    public static func buildEither(first component: [Action]) -> [Action] {
        return component
    }
    
    public static func buildEither(second component: [Action]) -> [Action] {
        return component
    }
    
    public static func buildBlock(_ components: Action...) -> [Action] {
        return .init(components)
    }
    
}
