//
//  KindKit
//

import Foundation

public extension Coder {

    struct URL : IValueCoder {
        
        public typealias JsonDecoded = Foundation.URL
        public typealias JsonEncoded = Foundation.URL
        typealias InternalCoder = Coder.String
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            guard let value = Foundation.URL(string: value) else {
                throw Error.Coding.cast(path)
            }
            return value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            return value.absoluteString as Foundation.NSString
        }
        
    }
    
}

extension URL : ICoderAlias {
    
    public typealias JsonDecoder = Coder.URL
    public typealias JsonEncoder = Coder.URL
    
}
