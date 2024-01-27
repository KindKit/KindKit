//
//  KindKit
//

public protocol ModelDecoderTrait {
    
    associatedtype JsonDecoded
    associatedtype JsonDecodeOptions : CodingOptions
    
    static func json(decode document: Document, with options: JsonDecodeOptions) throws -> JsonDecoded
    
    static func json(decode error: AccessError, with options: JsonDecodeOptions) throws -> JsonDecoded

}

public extension ModelDecoderTrait {
    
    @inlinable
    static func json(decode error: AccessError, with options: JsonDecodeOptions) throws -> JsonDecoded {
        throw error
    }
    
}

public extension ModelDecoderTrait where JsonDecodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func json(decode document: Document) throws -> JsonDecoded {
        return try self.json(decode: document, with: .default)
    }
    
}
