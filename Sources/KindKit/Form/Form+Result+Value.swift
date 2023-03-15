//
//  KindKit
//

import Foundation

public extension Form.Result {
    
    struct Value< Value > : IFormResult {
        
        public let id: Form.Id
        public let value: Value
        
        public init(id: Form.Id, value: Value) {
            self.id = id
            self.value = value
        }
        
        public func find(by id: Form.Id) -> IFormResult? {
            guard self.id == id else { return nil }
            return self
        }
        
    }
    
}

public extension IFormResult where Self == Form.Result.Value< Bool > {
    
    static func value(id: Form.Id, value: Bool) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormResult where Self == Form.Result.Value< Int > {
    
    static func value(id: Form.Id, value: Int) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormResult where Self == Form.Result.Value< UInt > {
    
    static func value(id: Form.Id, value: UInt) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormResult where Self == Form.Result.Value< Float > {
    
    static func value(id: Form.Id, value: Float) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormResult where Self == Form.Result.Value< Double > {
    
    static func value(id: Form.Id, value: Double) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormResult where Self == Form.Result.Value< Date > {
    
    static func value(id: Form.Id, value: Date) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormResult where Self == Form.Result.Value< String > {
    
    static func value(id: Form.Id, value: String) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormResult where Self == Form.Result.Value< URL > {
    
    static func value(id: Form.Id, value: URL) -> Self {
        return .init(id: id, value: value)
    }
    
}
