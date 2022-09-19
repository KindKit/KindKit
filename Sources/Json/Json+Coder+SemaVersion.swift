//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct SemaVersion : IJsonValueDecoder {
        
        public static func decode(_ value: IJsonValue) throws -> KindKit.SemaVersion {
            let string = try Json.Coder.String.decode(value)
            guard let version = KindKit.SemaVersion(string) else {
                throw Json.Error.cast
            }
            return version
        }
        
    }
    
}

extension SemaVersion : IJsonDecoderAlias {
    
    public typealias JsonDecoder = Json.Coder.SemaVersion
    
}
