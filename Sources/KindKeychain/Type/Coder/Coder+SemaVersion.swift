//
//  KindKit
//

import Foundation
import KindCore

public extension Coder {

    struct SemaVersion : IValueDecoder {
        
        public static func decode(_ value: Data) throws -> KindCore.SemaVersion {
            let string = try Coder.String.decode(value)
            guard let version = KindCore.SemaVersion(string) else {
                throw Error.cast
            }
            return version
        }
        
    }
    
}

extension SemaVersion : IDecoderAlias {
    
    public typealias KeychainDecoder = Coder.SemaVersion
    
}
