//
//  KindKit
//

public struct ForEachComponent : Component {
    
    public let part: Text.Part
    
    public init(
        count: Int,
        @Builder content: (Int) -> Text.Part
    ) {
        var accumulator = Text.Part()
        for index in 0 ..< count {
            accumulator.append(content(index))
        }
        self.part = accumulator
    }
    
    public init(
        count: Int,
        @Builder content: (Int) -> Text.Part,
        @Builder separator: () -> Text.Part
    ) {
        var accumulator = Text.Part()
        if count > 1 {
            for index in 0 ..< count - 1 {
                accumulator.append(content(index))
                accumulator.append(separator())
            }
            accumulator.append(content(count - 1))
        } else if count == 1 {
            accumulator.append(content(0))
        }
        self.part = accumulator
    }
    
    public init(
        count: Int,
        @Builder content: (Int) -> Text.Part,
        @Builder separator: () -> Text.Part,
        @Builder leading: () -> Text.Part,
        @Builder trailing: () -> Text.Part
    ) {
        var accumulator = Text.Part()
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
        self.part = accumulator
    }
    
}
