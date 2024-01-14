//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    func encode<
        Encoder : IValueEncoder
    >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        path: Path = .root
    ) throws {
        try self.set(
            path: path,
            encode: { path in
                return try encoder.encode(value, path: path)
            }
        )
    }
    
    @inlinable
    func encode<
        Encoder : IModelEncoder
    >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonModelEncoded,
        path: Path = .root
    ) throws {
        if (self.isEmpty == true || self.isDictionary == true) && path.isRoot == true {
            try Encoder.encode(value, json: self)
        } else {
            try self.encode(Coder.Model< Encoder >.self, value: value, path: path)
        }
    }
    
    @inlinable
    func encode<
        Alias : IEncoderAlias
    >(
        _ alias: Alias.Type,
        value: Alias.JsonEncoder.JsonEncoded,
        path: Path = .root
    ) throws {
        try self.encode(Alias.JsonEncoder.self, value: value, path: path)
    }
    
}

public extension Document {
    
    @inlinable
    func encode<
        Encoder : IValueEncoder
    >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded?,
        path: Path = .root,
        nullable: Bool = false
    ) throws {
        if let value = value {
            try self.encode(encoder, value: value, path: path)
        } else if nullable == true {
            try self.set(
                path: path,
                encode: { path in
                    return NSNull()
                }
            )
        }
    }
    
    @inlinable
    func encode<
        Encoder : IModelEncoder
    >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonModelEncoded?,
        path: Path = .root,
        nullable: Bool = false
    ) throws {
        try self.encode(Coder.Model< Encoder >.self, value: value, path: path, nullable: nullable)
    }
    
    @inlinable
    func encode<
        Alias : IEncoderAlias
    >(
        _ alias: Alias.Type,
        value: Alias.JsonEncoder.JsonEncoded?,
        path: Path = .root,
        nullable: Bool = false
    ) throws {
        try self.encode(Alias.JsonEncoder.self, value: value, path: path, nullable: nullable)
    }
    
}

public extension Document {
    
    func encode<
        Encoder : IValueEncoder
    >(
        _ encoder: Encoder.Type,
        value: [Encoder.JsonEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        try self.set(
            path: path,
            encode: { path in
                let array = NSMutableArray(capacity: value.count)
                if skipping == true {
                    for index in value.indices {
                        let subPath = path.appending(.index(index))
                        guard let encoded = try? encoder.encode(value[index], path: subPath) else { continue }
                        array.add(encoded)
                    }
                } else {
                    for index in value.indices {
                        let subPath = path.appending(.index(index))
                        let encoded = try encoder.encode(value[index], path: subPath)
                        array.add(encoded)
                    }
                }
                return array
            }
        )
    }
    
    @inlinable
    func encode<
        Encoder : IModelEncoder
    >(
        _ encoder: Encoder.Type,
        value: [Encoder.JsonModelEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        try self.encode(Coder.Model< Encoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode<
        Alias : IEncoderAlias
    >(
        _ alias: Alias.Type,
        value: [Alias.JsonEncoder.JsonEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Document {
    
    @inlinable
    func encode<
        Encoder : IValueEncoder
    >(
        _ encoder: Encoder.Type,
        value: [Encoder.JsonEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        if let value = value {
            try self.encode(encoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self.set(
                path: path,
                encode: { path in
                    return NSNull()
                }
            )
        }
    }
    
    @inlinable
    func encode<
        Encoder : IModelEncoder
    >(
        _ encoder: Encoder.Type,
        value: [Encoder.JsonModelEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        try self.encode(Coder.Model< Encoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode<
        Alias : IEncoderAlias
    >(
        _ alias: Alias.Type,
        value: [Alias.JsonEncoder.JsonEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
}

public extension Document {
    
    func encode<
        KeyEncoder : IValueEncoder,
        ValueEncoder : IValueEncoder
    >(
        _ keyEncoder: KeyEncoder.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyEncoder.JsonEncoded : ValueEncoder.JsonEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        try self.set(
            path: path,
            encode: { path in
                let dict = NSMutableDictionary(capacity: value.count)
                if skipping == true {
                    for item in value {
                        let keySubPath = path.appending(.key("\(item.key)"))
                        guard let encodedKey = try? keyEncoder.encode(item.key, path: keySubPath) else { continue }
                        let valueSubPath = path.appending(.key("\(encodedKey)"))
                        guard let encodedValue = try? valueEncoder.encode(item.value, path: valueSubPath) else { continue }
                        dict.setObject(encodedValue, forKey: encodedKey as! NSCopying)
                    }
                } else {
                    for item in value {
                        let keySubPath = path.appending(.key("\(item.key)"))
                        let encodedKey = try keyEncoder.encode(item.key, path: keySubPath)
                        let valueSubPath = path.appending(.key("\(encodedKey)"))
                        let encodedValue = try valueEncoder.encode(item.value, path: valueSubPath)
                        dict.setObject(encodedValue, forKey: encodedKey as! NSCopying)
                    }
                }
                return dict
            }
        )
    }
    
    @inlinable
    func encode<
        KeyEncoder : IValueEncoder,
        ValueEncoder : IModelEncoder
    >(
        _ keyEncoder: KeyEncoder.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyEncoder.JsonEncoded : ValueEncoder.JsonModelEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        return try self.encode(keyEncoder, Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode<
        KeyEncoder : IValueEncoder,
        ValueAlias : IEncoderAlias
    >(
        _ keyEncoder: KeyEncoder.Type,
        _ valueAlias: ValueAlias.Type,
        value: [KeyEncoder.JsonEncoded : ValueAlias.JsonEncoder.JsonEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        return try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode<
        KeyAlias : IEncoderAlias,
        ValueEncoder : IValueEncoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyAlias.JsonEncoder.JsonEncoded : ValueEncoder.JsonEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode<
        KeyAlias : IEncoderAlias,
        ValueEncoder : IModelEncoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyAlias.JsonEncoder.JsonEncoded : ValueEncoder.JsonModelEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode<
        KeyAlias : IEncoderAlias,
        ValueAlias : IEncoderAlias
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueAlias: ValueAlias.Type,
        value: [KeyAlias.JsonEncoder.JsonEncoded : ValueAlias.JsonEncoder.JsonEncoded],
        path: Path = .root,
        skipping: Bool = false
    ) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Document {
    
    @inlinable
    func encode<
        KeyEncoder : IValueEncoder,
        ValueEncoder : IValueEncoder
    >(
        _ keyEncoder: KeyEncoder.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyEncoder.JsonEncoded : ValueEncoder.JsonEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        if let value = value {
            try self.encode(keyEncoder, valueEncoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self.set(
                path: path,
                encode: { path in
                    return NSNull()
                }
            )
        }
    }
    
    @inlinable
    func encode<
        KeyEncoder : IValueEncoder,
        ValueEncoder : IModelEncoder
    >(
        _ keyEncoder: KeyEncoder.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyEncoder.JsonEncoded : ValueEncoder.JsonModelEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        try self.encode(keyEncoder, Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode<
        KeyEncoder : IValueEncoder,
        ValueAlias : IEncoderAlias
    >(
        _ keyEncoder: KeyEncoder.Type,
        _ valueAlias: ValueAlias.Type,
        value: [KeyEncoder.JsonEncoded : ValueAlias.JsonEncoder.JsonEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode<
        KeyAlias : IEncoderAlias,
        ValueEncoder : IValueEncoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyAlias.JsonEncoder.JsonEncoded : ValueEncoder.JsonEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode<
        KeyAlias : IEncoderAlias,
        ValueEncoder : IModelEncoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueEncoder: ValueEncoder.Type,
        value: [KeyAlias.JsonEncoder.JsonEncoded : ValueEncoder.JsonModelEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        try self.encode(KeyAlias.JsonEncoder.self, Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode<
        KeyAlias : IEncoderAlias,
        ValueAlias : IEncoderAlias
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueAlias: ValueAlias.Type,
        value: [KeyAlias.JsonEncoder.JsonEncoded : ValueAlias.JsonEncoder.JsonEncoded]?,
        path: Path = .root,
        skipping: Bool = false,
        nullable: Bool = false
    ) throws {
        try self.encode(KeyAlias.JsonEncoder.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
}

public extension Document {
    
    @inlinable
    func encode(
        dateFormat: String,
        value: Date,
        path: Path = .root
    ) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        try self.encode(
            String.self,
            value: formatter.string(from: value),
            path: path
        )
    }
    
    @inlinable
    func encode(
        dateFormat: String,
        value: Date?,
        path: Path = .root,
        nullable: Bool = false
    ) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        try self.encode(
            String.self,
            value: value.flatMap({ formatter.string(from: $0) }),
            path: path,
            nullable: nullable
        )
    }
    
}

public extension Document {
    
    @inlinable
    func encode< UnitType : Dimension >(
        value: Measurement< UnitType >,
        path: Path = .root
    ) throws {
        try self.encode(
            Double.self,
            value: value.value,
            path: path
        )
    }
    
    @inlinable
    func encode< UnitType : Unit >(
        value: Measurement< UnitType >?,
        path: Path = .root,
        nullable: Bool = false
    ) throws {
        try self.encode(
            Double.self,
            value: value?.value,
            path: path,
            nullable: nullable
        )
    }
    
}
