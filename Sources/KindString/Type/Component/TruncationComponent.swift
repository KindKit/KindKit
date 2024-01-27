//
//  KindKit
//

public struct TruncationComponent : IComponent {
    
    public let string: String
    
    public init(
        mode: TruncationMode,
        limit: Int,
        leader: String = "...",
        string: String
    ) {
        self.string = mode.apply(string, limit: limit, leader: leader)
    }
    
    public init(
        mode: TruncationMode,
        limit: Int,
        leader: String = "...",
        @Builder builder: () -> String
    ) {
        self.string = mode.apply(builder(), limit: limit, leader: leader)
    }
    
}
