//
//  KindKit
//

import Foundation

public extension Coder {

    struct String : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.String {
            return try Coder.NSString.decode(value) as Swift.String
        }
        
        public static func encode(_ value: Swift.String) throws -> IValue {
            return try Coder.NSString.encode(Foundation.NSString(string: value))
        }
        
    }
    
    struct NonEmptyString : IValueDecoder {
        
        public static func decode(_ value: IValue) throws -> Swift.String {
            let string = try Coder.String.decode(value)
            if string.isEmpty == true {
                throw Error.cast
            }
            return string
        }
        
    }
    
}

extension String : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.String
    public typealias UserDefaultsEncoder = Coder.String
    
}
