//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct URL : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Foundation.URL {
            let string = try UserDefaults.Coder.String.decode(value)
            guard let url = Foundation.URL(string: string) else {
                throw UserDefaults.Error.cast
            }
            return url
        }
        
        public static func encode(_ value: Foundation.URL) throws -> IUserDefaultsValue {
            return value.absoluteString as Foundation.NSString
        }
        
    }
    
}

extension URL : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.URL
    public typealias UserDefaultsEncoder = UserDefaults.Coder.URL
    
}
