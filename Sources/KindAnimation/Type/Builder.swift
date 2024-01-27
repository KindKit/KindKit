//
//  KindKit
//

@resultBuilder
public struct Builder {
    
    public static func buildExpression(_ component: IAction) -> IAction {
        return component
    }
    
    public static func buildOptional(_ component: [IAction]?) -> [IAction] {
        return component ?? []
    }
    
    public static func buildLimitedAvailability(_ component: [IAction]) -> [IAction] {
        return component
    }
    
    public static func buildEither(first component: [IAction]) -> [IAction] {
        return component
    }
    
    public static func buildEither(second component: [IAction]) -> [IAction] {
        return component
    }
    
    public static func buildBlock(_ components: IAction...) -> [IAction] {
        return .init(components)
    }
    
}
