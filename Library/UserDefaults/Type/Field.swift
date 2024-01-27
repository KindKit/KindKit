//
//  KindKit
//

import Foundation

public protocol Field {
    
    func isEqual(_ value: any Field) -> Bool
    
}

extension NSNull : Field {
    
    public func isEqual(_ value: any Field) -> Bool {
        return self.isEqual(value as Any)
    }
    
}

extension NSString : Field {
    
    public func isEqual(_ value: any Field) -> Bool {
        return self.isEqual(value as Any)
    }
    
}

extension NSNumber : Field {
    
    public func isEqual(_ value: any Field) -> Bool {
        return self.isEqual(value as Any)
    }
    
}

extension NSArray : Field {
    
    public func isEqual(_ value: any Field) -> Bool {
        return self.isEqual(value as Any)
    }
    
}

extension NSDictionary : Field {
    
    public func isEqual(_ value: any Field) -> Bool {
        return self.isEqual(value as Any)
    }
    
}
