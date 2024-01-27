//
//  KindKit
//

public protocol ModelEncoderTrait {
    
    associatedtype JsonEncoded
    associatedtype JsonEncodeOptions : CodingOptions
    
    static func json(encode model: JsonEncoded, from document: Document, with options: JsonEncodeOptions) throws
    
}

public extension ModelEncoderTrait {
    
    static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        let document = Document(in: path)
        try Self.json(encode: value, from: document, with: options)
        guard let root = document.root else {
            throw CodingError(in: path)
        }
        return root
    }

}

public extension ModelEncoderTrait where JsonEncodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func json(encode model: JsonEncoded, from json: Document) throws {
        try self.json(encode: model, from: json, with: .default)
    }
    
}
