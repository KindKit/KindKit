//
//  KindKit
//

import Foundation

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Encoder.JsonEncoded) throws {
        try self.set(value: try encoder.encode(value))
    }
    
    @inlinable
    func encode< Encoder : IJsonModelEncoder >(_ encoder: Encoder.Type, value: Encoder.Model) throws {
        if self.isEmpty == true || self.isDictionary == true {
            try Encoder.encode(value, json: self)
        } else {
            try self.encode(Json.Coder.Model< Encoder >.self, value: value)
        }
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Alias.JsonEncoder.JsonEncoded) throws {
        try self.encode(Alias.JsonEncoder.self, value: value)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Encoder.JsonEncoded, path: String) throws {
        try self.set(value: try encoder.encode(value), path: path)
    }
    
    @inlinable
    func encode< Encoder : IJsonModelEncoder >(_ encoder: Encoder.Type, value: Encoder.Model, path: String) throws {
        try self.encode(Json.Coder.Model< Encoder >.self, value: value, path: path)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Alias.JsonEncoder.JsonEncoded, path: String) throws {
        try self.encode(Alias.JsonEncoder.self, value: value, path: path)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Array< Encoder.JsonEncoded >, skipping: Bool = false) throws {
        let jsonValue = NSMutableArray(capacity: value.count)
        if skipping == true {
            for item in value {
                guard let value = try? encoder.encode(item) else { continue }
                jsonValue.add(value)
            }
        } else {
            for item in value {
                jsonValue.add(try encoder.encode(item))
            }
        }
        try self.set(value: jsonValue)
    }
    
    @inlinable
    func encode< Encoder : IJsonModelEncoder >(_ encoder: Encoder.Type, value: Array< Encoder.Model >, skipping: Bool = false) throws {
        try self.encode(Json.Coder.Model< Encoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Array< Alias.JsonEncoder.JsonEncoded >, skipping: Bool = false) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.JsonEncoded, ValueEncoder.JsonEncoded >, skipping: Bool = false) throws {
        let jsonValue = NSMutableDictionary(capacity: value.count)
        if skipping == true {
            for item in value {
                guard let key = try? keyEncoder.encode(item.key) else { continue }
                guard let value = try? valueEncoder.encode(item.value) else { continue }
                jsonValue.setObject(key, forKey: value as! NSCopying)
            }
        } else {
            for item in value {
                let key = try keyEncoder.encode(item.key)
                let value = try valueEncoder.encode(item.value)
                jsonValue.setObject(key, forKey: value as! NSCopying)
            }
        }
        try self.set(value: jsonValue)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.JsonEncoded, ValueEncoder.Model >, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, Json.Coder.Model< ValueEncoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.JsonEncoded, ValueAlias.JsonEncoder.JsonEncoded >, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.JsonEncoded >, skipping: Bool = false) throws {
        return try self.encode(Json.Coder.Model< KeyEncoder >.self, valueEncoder, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.Model >, skipping: Bool = false) throws {
        return try self.encode(Json.Coder.Model< KeyEncoder >.self, Json.Coder.Model< ValueEncoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.Model, ValueAlias.JsonEncoder.JsonEncoded >, skipping: Bool = false) throws {
        return try self.encode(Json.Coder.Model< KeyEncoder >.self, ValueAlias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonValueEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueEncoder.JsonEncoded >, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonModelEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueEncoder.Model >, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, Json.Coder.Model< ValueEncoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueAlias.JsonEncoder.JsonEncoded >, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, ValueAlias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Optional< Encoder.JsonEncoded >, path: String, nullable: Bool = false) throws {
        if let value = value {
            try self._set(value: try encoder.encode(value), path: path)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< Encoder : IJsonModelEncoder >(_ encoder: Encoder.Type, value: Optional< Encoder.Model >, path: String, nullable: Bool = false) throws {
        try self.encode(Json.Coder.Model< Encoder >.self, value: value, path: path, nullable: nullable)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Optional< Alias.JsonEncoder.JsonEncoded >, path: String, nullable: Bool = false) throws {
        try self.encode(Alias.JsonEncoder.self, value: value, path: path, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Array< Encoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        let jsonValue = NSMutableArray(capacity: value.count)
        if skipping == true {
            for item in value {
                guard let value = try? encoder.encode(item) else { continue }
                jsonValue.add(value)
            }
        } else {
            for item in value {
                jsonValue.add(try encoder.encode(item))
            }
        }
        try self.set(value: jsonValue, path: path)
    }
    
    @inlinable
    func encode< Encoder : IJsonModelEncoder >(_ encoder: Encoder.Type, value: Array< Encoder.Model >, path: String, skipping: Bool = false) throws {
        try self.encode(Json.Coder.Model< Encoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Array< Alias.JsonEncoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Optional< Array< Encoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        if let value = value {
            try self.encode(encoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< Encoder : IJsonModelEncoder >(_ encoder: Encoder.Type, value: Optional< Array< Encoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(Json.Coder.Model< Encoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Optional< Array< Alias.JsonEncoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.JsonEncoded, ValueEncoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        let jsonValue = NSMutableDictionary(capacity: value.count)
        if skipping == true {
            for item in value {
                guard let key = try? keyEncoder.encode(item.key) else { continue }
                guard let value = try? valueEncoder.encode(item.value) else { continue }
                jsonValue.setObject(key, forKey: value as! NSCopying)
            }
        } else {
            for item in value {
                let key = try keyEncoder.encode(item.key)
                let value = try valueEncoder.encode(item.value)
                jsonValue.setObject(key, forKey: value as! NSCopying)
            }
        }
        try self.set(value: jsonValue, path: path)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.JsonEncoded, ValueEncoder.Model >, path: String, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, Json.Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.JsonEncoded, ValueAlias.JsonEncoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        return try self.encode(Json.Coder.Model< KeyEncoder >.self, valueEncoder, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.Model >, path: String, skipping: Bool = false) throws {
        return try self.encode(Json.Coder.Model< KeyEncoder >.self, Json.Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.Model, ValueAlias.JsonEncoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        return try self.encode(Json.Coder.Model< KeyEncoder >.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonValueEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueEncoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonModelEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueEncoder.Model >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, Json.Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueAlias.JsonEncoder.JsonEncoded >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.JsonEncoded, ValueEncoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        if let value = value {
            try self.encode(keyEncoder, valueEncoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.JsonEncoded, ValueEncoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(keyEncoder, Json.Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyEncoder.JsonEncoded, ValueAlias.JsonEncoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.Model, ValueEncoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(Json.Coder.Model< KeyEncoder >.self, valueEncoder, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.Model, ValueEncoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(Json.Coder.Model< KeyEncoder >.self, Json.Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyEncoder.Model, ValueAlias.JsonEncoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(Json.Coder.Model< KeyEncoder >.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonValueEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueEncoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonModelEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueEncoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAlias.JsonEncoder.self, Json.Coder.Model< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyAlias.JsonEncoder.JsonEncoded, ValueAlias.JsonEncoder.JsonEncoded > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAlias.JsonEncoder.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode(_ dateFormat: String, value: Date, path: String) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        try self.encode(String.self, value: formatter.string(from: value))
    }
    
}
