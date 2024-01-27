//
//  KindKit
//

import Foundation
import KindJSON

struct JsonEncoder< Model : ModelEncoderTrait > : ValueEncoderTrait {
    
    typealias KeychainEncoded = Model.JsonEncoded
    typealias KeychainEncodeOptions = Model.JsonEncodeOptions
    
    static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        do {
            return try KindJSON.Document.build(data: {
                try $0.encode(Model.self, value: value, with: options)
            })
        } catch {
            throw CodingError(in: key)
        }
    }
    
}
