//
//  KindKit
//

public protocol Info : Sendable {
    
    func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String
    
}

public extension Info {
    
    @inlinable
    func string(
        options: Options = []
    ) -> String {
        return self.build(
            options: options
        )
    }
    
    @inlinable
    func build(
        options: Options,
        head: UInt = 0,
        inter: UInt = 1,
        tail: UInt = 0
    ) -> String {
        return self.build(
            options: options,
            head: head,
            inter: inter,
            tail: tail
        )
    }
    
}
