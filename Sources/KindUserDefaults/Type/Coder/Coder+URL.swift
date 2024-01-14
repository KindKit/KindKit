//
//  KindKit
//

import Foundation

public extension Coder {

    struct URL : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Foundation.URL {
            let string = try Coder.String.decode(value)
            guard let url = Foundation.URL(string: string) else {
                throw Error.cast
            }
            return url
        }
        
        public static func encode(_ value: Foundation.URL) throws -> IValue {
            return value.absoluteString as Foundation.NSString
        }
        
    }
    
}

extension URL : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.URL
    public typealias UserDefaultsEncoder = Coder.URL
    
}
