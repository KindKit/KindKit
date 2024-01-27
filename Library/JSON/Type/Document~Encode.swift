//
//  KindKit
//

import Foundation
import KindCodingOptions

public extension Document {
    
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded
    ) throws where Encoder.JsonEncodeOptions : DefaultCodingOptions {
        try self.encode(encoder, value: value, in: .root, with: .default)
    }
    
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        in path: Path
    ) throws where Encoder.JsonEncodeOptions : DefaultCodingOptions {
        try self.encode(encoder, value: value, in: path, with: .default)
    }
    
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        with options: Encoder.JsonEncodeOptions
    ) throws {
        try self.encode(encoder, value: value, in: .root, with: options)
    }
    
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        in path: Path,
        with options: Encoder.JsonEncodeOptions
    ) throws {
        let value = try Encoder.json(encode: value, in: self.path.appending(path), with: options)
        if let value = value {
            try self.set(query: .insert(value), in: path)
        }
    }
    
}

public extension Document {
    
    @inlinable
    func encode< Encoder : ModelEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded
    ) throws where Encoder.JsonEncodeOptions : DefaultCodingOptions {
        try self.encode(encoder, value: value, in: .root, with: .default)
    }
    
    @inlinable
    func encode< Encoder : ModelEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        in path: Path
    ) throws where Encoder.JsonEncodeOptions : DefaultCodingOptions {
        try self.encode(encoder, value: value, in: path, with: .default)
    }
    
    @inlinable
    func encode< Encoder : ModelEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        with options: Encoder.JsonEncodeOptions
    ) throws {
        try self.encode(encoder, value: value, in: path, with: options)
    }
    
    func encode< Encoder : ModelEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        in path: Path,
        with options: Encoder.JsonEncodeOptions
    ) throws {
        if (self.isEmpty == true || self.isDictionary == true) && path.isRoot == true {
            try Encoder.json(encode: value, from: self, with: options)
        } else {
            let value = try Encoder.json(encode: value, in: self.path.appending(path), with: options)
            if let value = value {
                try self.set(query: .insert(value), in: path)
            }
        }
    }
    
}
