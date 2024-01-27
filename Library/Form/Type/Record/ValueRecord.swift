//
//  KindKit
//

import KindCore

struct ValueRecord< Value : Equatable > : Record {
    
    public let id: Id
    public let value: Value
    
    public init(
        id: Id,
        value: Value
    ) {
        self.id = id
        self.value = value
    }
    
    public func isEquivalent(to record: any Record) -> Bool {
        guard self.id == record.id else { return false }
        return self.value == record.value(as: Value.self)
    }
    
    public func record(by id: Id) -> (any Record)? {
        guard self.id == id else { return nil }
        return self
    }
    
    public func value< Cast >(as type: Cast.Type) -> Cast? {
        return self.value as? Cast
    }
    
}
