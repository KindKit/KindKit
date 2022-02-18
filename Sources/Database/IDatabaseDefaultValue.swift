//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseDefaultValue {
    
    func queryDefaultValue() -> String
    
}

public extension Database {
    
    struct DefaultValueEmptyData : IDatabaseDefaultValue {
        
        public func queryDefaultValue() -> String {
            return "EMPTY_BLOB()"
        }
        
    }
    
}

extension Bool : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return (self == true) ? "1" : "0"
    }
    
}

extension Int8 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension UInt8 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension Int16 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension UInt16 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension Int32 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension UInt32 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension Int64 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension UInt64 : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension Int : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension UInt : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension Float : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension Double : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\(self)"
    }
    
}

extension String : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\"\(self)\""
    }
    
}

extension URL : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return self.absoluteString.queryDefaultValue()
    }
    
}

extension Date : IDatabaseDefaultValue {
    
    public func queryDefaultValue() -> String {
        return "\"\(Int64(self.timeIntervalSince1970))\""
    }
    
}
