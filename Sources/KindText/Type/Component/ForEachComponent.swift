//
//  KindKit
//

public struct ForEachComponent : IComponent {
    
    public let text: Text
    
    public init(
        count: Int,
        @Builder content: (Int) -> Text
    ) {
        var accumulator = Text()
        for index in 0 ..< count {
            accumulator.append(content(index))
        }
        self.text = accumulator
    }
    
    public init(
        count: Int,
        @Builder content: (Int) -> Text,
        @Builder separator: () -> Text
    ) {
        var accumulator = Text()
        if count > 1 {
            for index in 0 ..< count - 1 {
                accumulator.append(content(index))
                accumulator.append(separator())
            }
            accumulator.append(content(count - 1))
        } else if count == 1 {
            accumulator.append(content(0))
        }
        self.text = accumulator
    }
    
    public init(
        count: Int,
        @Builder content: (Int) -> Text,
        @Builder separator: () -> Text,
        @Builder leading: () -> Text,
        @Builder trailing: () -> Text
    ) {
        var accumulator = Text()
        accumulator.append(leading())
        if count > 1 {
            for index in 0 ..< count - 1 {
                accumulator.append(content(index))
                accumulator.append(separator())
            }
            accumulator.append(content(count - 1))
        } else if count == 1 {
            accumulator.append(content(0))
        }
        accumulator.append(trailing())
        self.text = accumulator
    }
    
}
