//
//  KindKit
//

import Foundation
import KindCodingOptions

public extension Document {
    
    func decode<
        Success,
        Failure : Swift.Error
    >(
        success: (Document) throws -> Success,
        failure: (Document) throws -> Failure
    ) throws -> Result< Success, Failure > {
        do {
            return .success(try success(self))
        } catch let error {
            do {
                return .failure(try failure(self))
            } catch _ {
                throw error
            }
        }
    }
    
}

public extension Document {
    
    @inlinable
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type
    ) throws -> Decoder.JsonDecoded where Decoder.JsonDecodeOptions : DefaultCodingOptions {
        return try self.decode(decoder, in: .root, with: .default)
    }
    
    @inlinable
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type,
        in path: Path
    ) throws -> Decoder.JsonDecoded where Decoder.JsonDecodeOptions : DefaultCodingOptions {
        return try self.decode(decoder, in: path, with: .default)
    }
    
    @inlinable
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type,
        with options: Decoder.JsonDecodeOptions
    ) throws -> Decoder.JsonDecoded {
        return try self.decode(decoder, in: path, with: options)
    }
    
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type,
        in path: Path,
        with options: Decoder.JsonDecodeOptions
    ) throws -> Decoder.JsonDecoded {
        return try self.get(
            in: path,
            decodeValue: { value, path in
                try Decoder.json(decode: value, in: path, with: options)
            },
            decodeError: { error, path in
                try Decoder.json(decode: error, with: options)
            }
        )
    }
    
}

public extension Document {
    
    @inlinable
    func decode< Decoder : ModelDecoderTrait >(
        _ decoder: Decoder.Type
    ) throws -> Decoder.JsonDecoded where Decoder.JsonDecodeOptions : DefaultCodingOptions {
        return try self.decode(decoder, in: .root, with: .default)
    }
    
    @inlinable
    func decode< Decoder : ModelDecoderTrait >(
        _ decoder: Decoder.Type,
        in path: Path
    ) throws -> Decoder.JsonDecoded where Decoder.JsonDecodeOptions : DefaultCodingOptions {
        return try self.decode(decoder, in: path, with: .default)
    }
    
    @inlinable
    func decode< Decoder : ModelDecoderTrait >(
        _ decoder: Decoder.Type,
        with options: Decoder.JsonDecodeOptions
    ) throws -> Decoder.JsonDecoded {
        return try self.decode(decoder, in: path, with: options)
    }
    
    func decode< Decoder : ModelDecoderTrait >(
        _ decoder: Decoder.Type,
        in path: Path,
        with options: Decoder.JsonDecodeOptions
    ) throws -> Decoder.JsonDecoded {
        return try self.get(
            in: path,
            decodeValue: { value, path in
                try Decoder.json(decode: .init(in: path, root: value), with: options)
            },
            decodeError: { error, path in
                try Decoder.json(decode: error, with: options)
            }
        )
    }
    
}
