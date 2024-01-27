//
//  KindKit
//

public struct ForEachComponent : IComponent {
    
    public let string: String
    
    public init(
        count: Int,
        @Builder content: (Int) -> String
    ) {
        var accumulator: [String] = []
        for index in 0 ..< count {
            accumulator.append(content(index))
        }
        self.string = accumulator.joined()
    }
    
    public init(
        count: Int,
        @Builder content: (Int) -> String,
        @Builder separator: () -> String
    ) {
        var accumulator: [String] = []
        for index in 0 ..< count {
            accumulator.append(content(index))
        }
        self.string = accumulator.joined(separator: separator())
    }
    
    public init(
        count: Int,
        @Builder content: (Int) -> String,
        @Builder separator: () -> String,
        @Builder leading: () -> String,
        @Builder trailing: () -> String
    ) {
        var accumulator: [String] = []
        for index in 0 ..< count {
            accumulator.append(content(index))
        }
        let leading = leading()
        let trailing = trailing()
        var result: String = ""
        result.append(leading)
        result.append(accumulator.joined(separator: separator()))
        result.append(trailing)
        self.string = result
    }
    
}
