//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct SemaVersionJsonCoder : IJsonValueDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> SemaVersion {
        let string = try StringJsonCoder.decode(value)
        guard let version = SemaVersion(string) else { throw JsonError.cast }
        return version
    }
    
}

extension SemaVersion : IJsonDecoderAlias {
    
    public typealias JsonDecoder = SemaVersionJsonCoder
    
}
