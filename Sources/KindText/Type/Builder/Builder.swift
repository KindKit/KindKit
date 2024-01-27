//
//  KindKit
//

@resultBuilder
public struct Builder {
    
    public static func buildExpression(_ expression: IComponent) -> IComponent {
        return expression
    }
    
    public static func buildEither(first component: IComponent) -> IComponent {
        return component
    }
    
    public static func buildEither(second component: IComponent) -> IComponent {
        return component
    }
    
    public static func buildOptional(_ component: IComponent?) -> IComponent {
        return component ?? EmptyComponent()
    }
    
    public static func buildLimitedAvailability(_ component: IComponent) -> IComponent {
        return component
    }
    
    public static func buildBlock(_ components: IComponent...) -> IComponent {
        if components.count > 1 {
            return ForEachComponent(count: components.count, content: { components[$0] })
        } else if components.count > 0 {
            return components[0]
        }
        return EmptyComponent()
    }
    
    public static func buildArray(_ components: [IComponent]) -> IComponent {
        return ForEachComponent(count: components.count, content: { components[$0] })
    }
    
    public static func buildFinalResult(_ component: IComponent) -> Text {
        return component.text
    }
    
}

public extension String {
    
    static func kk_build(@Builder _ builder: () -> String) -> Self {
        return builder()
    }
    
}
