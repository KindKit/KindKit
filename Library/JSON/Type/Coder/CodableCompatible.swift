//
//  KindKit
//

import Foundation
import KindCodingOptions

public struct CodableCompatible< Model > {
}

extension CodableCompatible : ModelDecoderTrait where Model : Decodable {
    
    public typealias JsonDecoded = Model
    public typealias JsonDecodeOptions = EmptyCodingOptions
    
    public static func json(decode document: Document, with options: JsonDecodeOptions) throws -> JsonDecoded {
        do {
            return try JSONDecoder().decode(Model.self, from: try document.asData())
        } catch {
            throw CodingError(in: document.path)
        }
    }
    
}

extension CodableCompatible : ModelEncoderTrait where Model : Encodable {
    
    public typealias JsonEncoded = Model
    public typealias JsonEncodeOptions = EmptyCodingOptions
    
    public static func json(encode model: JsonEncoded, from document: Document, with options: JsonEncodeOptions) throws {
        let encoder = JSONEncoder()
        do {
            try document.set(root: try encoder.encode(model))
        } catch {
            throw CodingError(in: document.path)
        }
    }
    
}
