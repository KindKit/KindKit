//
//  KindKit
//

import Foundation

public extension Coder {

    struct String : IValueCoder {
        
        public typealias JsonDecoded = Swift.String
        public typealias JsonEncoded = Swift.String
        typealias InternalCoder = Coder.NSString
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value as Swift.String
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSString(string: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
    struct NonEmptyString : IValueDecoder {
        
        public typealias JsonDecoded = Swift.String
        typealias InternalCoder = Coder.String
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            if value.isEmpty == true {
                throw Error.Coding.cast(path)
            }
            return value
        }
        
    }
    
}

extension String : ICoderAlias {
    
    public typealias JsonDecoder = Coder.String
    public typealias JsonEncoder = Coder.String
    
}
