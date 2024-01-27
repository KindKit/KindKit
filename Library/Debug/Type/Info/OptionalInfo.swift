//
//  KindKit
//

public struct OptionalInfo< Info : KindDebug.Info > : KindDebug.Info {
    
    public let info: Info?
    
    public init(_ info: Info?) {
        self.info = info
    }
    
    public func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String {
        guard let info = self.info else {
            return ""
        }
        return info.build(
            options: options,
            head: head,
            inter: inter,
            tail: tail
        )
    }
    
}
