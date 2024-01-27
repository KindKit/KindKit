//
//  KindKit
//

import Foundation
import KindJSON

struct JsonDecoder< Model : ModelDecoderTrait > : ValueDecoderTrait {
    
    typealias KeychainDecoded = Model.JsonDecoded
    typealias KeychainDecodeOptions = Model.JsonDecodeOptions
    
    static func keychain(decode value: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        do {
            return try KindJSON.Document.parse(data: value, decode: {
                try $0.decode(Model.self, with: options)
            })
        } catch {
            throw CodingError(in: key)
        }
    }
    
}
