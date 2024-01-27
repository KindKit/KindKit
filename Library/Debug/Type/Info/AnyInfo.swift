//
//  KindKit
//

public struct AnyInfo : Info {
    
    public let value: Info
    
    public init(_ value: Info) {
        self.value = value
    }
    
    public init(_ value: DebugTrait) {
        self.value = value.buildInfo()
    }
    
    public func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String {
        self.value.build(
            options: options,
            head: head,
            inter: inter,
            tail: tail
        )
    }
    
}
