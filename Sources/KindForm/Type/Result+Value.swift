//
//  KindKit
//

import Foundation

public extension Result {
    
    struct Value< Value > : IResult {
        
        public let id: Id
        public let value: Value
        
        public init(id: Id, value: Value) {
            self.id = id
            self.value = value
        }
        
        public func find(by id: Id) -> IResult? {
            guard self.id == id else { return nil }
            return self
        }
        
    }
    
}
public extension Result {
    
    static func value(id: Id, value: Bool) -> Value< Bool > {
        return .init(id: id, value: value)
    }
    
    static func value(id: Id, value: Int) -> Value< Int > {
        return .init(id: id, value: value)
    }
    
    static func value(id: Id, value: UInt) -> Value< UInt > {
        return .init(id: id, value: value)
    }
    
    static func value(id: Id, value: Float) -> Value< Float > {
        return .init(id: id, value: value)
    }
    
    static func value(id: Id, value: Double) -> Value< Double > {
        return .init(id: id, value: value)
    }
    
    static func value(id: Id, value: Date) -> Value< Date > {
        return .init(id: id, value: value)
    }
    
    static func value(id: Id, value: String) -> Value< String > {
        return .init(id: id, value: value)
    }
    
    static func value(id: Id, value: URL) -> Value< URL > {
        return .init(id: id, value: value)
    }
    
}
