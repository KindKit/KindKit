//
//  KindKit
//

import Foundation

public extension Coder {

    struct Date : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Foundation.Date {
            let number = try Coder.NSNumber.decode(value)
            return Foundation.Date(timeIntervalSince1970: number.doubleValue)
        }
        
        public static func encode(_ value: Foundation.Date) throws -> IValue {
            return try Coder.NSNumber.encode(Foundation.NSNumber(value: Swift.Int(value.timeIntervalSince1970)))
        }
        
    }
    
}

extension Date : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Date
    public typealias UserDefaultsEncoder = Coder.Date
    
}
