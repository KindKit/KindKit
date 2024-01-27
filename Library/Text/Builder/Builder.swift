//
//  KindKit
//

@resultBuilder
public struct Builder {
    
    public static func buildExpression(_ expression: any Component) -> any Component {
        return expression
    }
    
    public static func buildEither(first component: any Component) -> any Component {
        return component
    }
    
    public static func buildEither(second component: any Component) -> any Component {
        return component
    }
    
    public static func buildOptional(_ component: (any Component)?) -> any Component {
        return component ?? EmptyComponent()
    }
    
    public static func buildLimitedAvailability(_ component: any Component) -> any Component {
        return component
    }
    
    public static func buildBlock(_ components: (any Component)...) -> any Component {
        if components.count > 1 {
            return ForEachComponent(count: components.count, content: { components[$0] })
        } else if components.count > 0 {
            return components[0]
        }
        return EmptyComponent()
    }
    
    public static func buildArray(_ components: [any Component]) -> any Component {
        return ForEachComponent(count: components.count, content: { components[$0] })
    }
    
    public static func buildFinalResult(_ component: any Component) -> Text.Part {
        return component.part
    }
    
}

public extension String {
    
    static func kk_build(@Builder _ builder: () -> String) -> Self {
        return builder()
    }
    
}
