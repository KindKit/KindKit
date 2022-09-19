//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct String : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.String {
            return try UserDefaults.Coder.NSString.decode(value) as Swift.String
        }
        
        public static func encode(_ value: Swift.String) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSString.encode(Foundation.NSString(string: value))
        }
        
    }
    
    struct NonEmptyString : IUserDefaultsValueDecoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.String {
            let string = try UserDefaults.Coder.String.decode(value)
            if string.isEmpty == true {
                throw UserDefaults.Error.cast
            }
            return string
        }
        
    }
    
}

extension String : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.String
    public typealias UserDefaultsEncoder = UserDefaults.Coder.String
    
}
