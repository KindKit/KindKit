//
//  KindKit
//

@resultBuilder
public struct Builder {
    
    public static func buildExpression(_ expression: Component) -> Component {
        return expression
    }
    
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? EmptyComponent()
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Component {
        return component
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        if components.count > 1 {
            return ForEachComponent(count: components.count, content: { components[$0] })
        } else if components.count > 0 {
            return components[0]
        }
        return EmptyComponent()
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        return ForEachComponent(count: components.count, content: { components[$0] })
    }
    
    public static func buildFinalResult(_ component: Component) -> String {
        return component.string
    }
    
}

public extension String {
    
    static func kk_build(@Builder _ builder: () -> String) -> Self {
        return builder()
    }
    
}
