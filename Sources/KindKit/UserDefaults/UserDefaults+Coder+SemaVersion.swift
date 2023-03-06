//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct SemaVersion : IUserDefaultsValueDecoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> KindKit.SemaVersion {
            let string = try UserDefaults.Coder.String.decode(value)
            guard let version = KindKit.SemaVersion(string) else {
                throw UserDefaults.Error.cast
            }
            return version
        }
        
    }
    
}

extension SemaVersion : IUserDefaultsDecoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.SemaVersion
    
}
