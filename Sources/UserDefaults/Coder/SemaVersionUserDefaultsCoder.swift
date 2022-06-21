//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public struct SemaVersionUserDefaultsCoder : IUserDefaultsValueDecoder {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> SemaVersion {
        let string = try StringUserDefaultsCoder.decode(value)
        guard let url = SemaVersion(string) else { throw Error.cast }
        return url
    }
    
}

extension SemaVersion : IUserDefaultsDecoderAlias {
    
    public typealias UserDefaultsDecoderType = SemaVersionUserDefaultsCoder
    
}
