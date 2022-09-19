//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Float : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Float {
            return try UserDefaults.Coder.NSNumber.decode(value).floatValue
        }
        
        public static func encode(_ value: Swift.Float) throws -> IUserDefaultsValue {
            return try UserDefaults.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Float : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Float
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Float
    
}
