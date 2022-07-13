//
//  KindKitJson
//

import Foundation
import KindKitCore

public extension Json {
    
    func encode< Encoder: IJsonValueEncoder >(_ encoder: Encoder.Type, value: Encoder.Value) throws {
        try self.set(value: try encoder.encode(value))
    }
    
    @inlinable
    func encode< Encoder: IJsonModelEncoder >(_ encoder: Encoder.Type, value: Encoder.Model) throws {
        if self.isEmpty == true || self.isDictionary == true {
            try Encoder.encode(value, json: self)
        } else {
            try self.encode(ModelJsonEncoder< Encoder >.self, value: value)
        }
    }
    
    @inlinable
    func encode< Alias: IJsonEncoderAlias >(_ alias: Alias.Type, value: Alias.JsonEncoder.Value) throws {
        try self.encode(Alias.JsonEncoder.self, value: value)
    }
    
}

public extension Json {
    
    func encode< Encoder: IJsonValueEncoder >(_ encoder: Encoder.Type, value: Encoder.Value, path: String) throws {
        try self.set(value: try encoder.encode(value), path: path)
    }
    
    @inlinable
    func encode< Encoder: IJsonModelEncoder >(_ encoder: Encoder.Type, value: Encoder.Model, path: String) throws {
        try self.encode(ModelJsonEncoder< Encoder >.self, value: value, path: path)
    }
    
    @inlinable
    func encode< Alias: IJsonEncoderAlias >(_ alias: Alias.Type, value: Alias.JsonEncoder.Value, path: String) throws {
        try self.encode(Alias.JsonEncoder.self, value: value, path: path)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Array< Encoder.Value >, skipping: Bool = false) throws {
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
        try self.encode(ModelJsonEncoder< Encoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Array< Alias.JsonEncoder.Value >, skipping: Bool = false) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Value, ValueEncoder.Value >, skipping: Bool = false) throws {
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
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Value, ValueEncoder.Model >, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ModelJsonEncoder< ValueEncoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.Value, ValueAlias.JsonEncoder.Value >, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.Value >, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoder >.self, valueEncoder, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.Model >, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoder >.self, ModelJsonEncoder< ValueEncoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.Model, ValueAlias.JsonEncoder.Value >, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoder >.self, ValueAlias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonValueEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.Value, ValueEncoder.Value >, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonModelEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.Value, ValueEncoder.Model >, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, ModelJsonEncoder< ValueEncoder >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyAlias.JsonEncoder.Value, ValueAlias.JsonEncoder.Value >, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, ValueAlias.JsonEncoder.self, value: value, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< Encoder: IJsonValueEncoder >(_ encoder: Encoder.Type, value: Optional< Encoder.Value >, path: String, nullable: Bool = false) throws {
        if let value = value {
            try self._set(value: try encoder.encode(value), path: path)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< Encoder: IJsonModelEncoder >(_ encoder: Encoder.Type, value: Optional< Encoder.Model >, path: String, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< Encoder >.self, value: value, path: path, nullable: nullable)
    }
    
    @inlinable
    func encode< Alias: IJsonEncoderAlias >(_ alias: Alias.Type, value: Optional< Alias.JsonEncoder.Value >, path: String, nullable: Bool = false) throws {
        try self.encode(Alias.JsonEncoder.self, value: value, path: path, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Array< Encoder.Value >, path: String, skipping: Bool = false) throws {
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
        try self.encode(ModelJsonEncoder< Encoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Array< Alias.JsonEncoder.Value >, path: String, skipping: Bool = false) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< Encoder : IJsonValueEncoder >(_ encoder: Encoder.Type, value: Optional< Array< Encoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        if let value = value {
            try self.encode(encoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< Encoder : IJsonModelEncoder >(_ encoder: Encoder.Type, value: Optional< Array< Encoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< Encoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< Alias : IJsonEncoderAlias >(_ alias: Alias.Type, value: Optional< Array< Alias.JsonEncoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        return try self.encode(Alias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Value, ValueEncoder.Value >, path: String, skipping: Bool = false) throws {
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
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Value, ValueEncoder.Model >, path: String, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ModelJsonEncoder< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.Value, ValueAlias.JsonEncoder.Value >, path: String, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.Value >, path: String, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoder >.self, valueEncoder, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyEncoder.Model, ValueEncoder.Model >, path: String, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoder >.self, ModelJsonEncoder< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoder.Model, ValueAlias.JsonEncoder.Value >, path: String, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoder >.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonValueEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.Value, ValueEncoder.Value >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonModelEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Dictionary< KeyAlias.JsonEncoder.Value, ValueEncoder.Model >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, ModelJsonEncoder< ValueEncoder >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyAlias.JsonEncoder.Value, ValueAlias.JsonEncoder.Value >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAlias.JsonEncoder.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.Value, ValueEncoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        if let value = value {
            try self.encode(keyEncoder, valueEncoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.Value, ValueEncoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(keyEncoder, ModelJsonEncoder< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyEncoder.Value, ValueAlias.JsonEncoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(keyEncoder, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonValueEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.Model, ValueEncoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< KeyEncoder >.self, valueEncoder, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueEncoder : IJsonModelEncoder >(_ keyEncoder: KeyEncoder.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyEncoder.Model, ValueEncoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< KeyEncoder >.self, ModelJsonEncoder< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoder : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoder.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyEncoder.Model, ValueAlias.JsonEncoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< KeyEncoder >.self, ValueAlias.JsonEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonValueEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyAlias.JsonEncoder.Value, ValueEncoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAlias.JsonEncoder.self, valueEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueEncoder : IJsonModelEncoder >(_ keyAlias: KeyAlias.Type, _ valueEncoder: ValueEncoder.Type, value: Optional< Dictionary< KeyAlias.JsonEncoder.Value, ValueEncoder.Model > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAlias.JsonEncoder.self, ModelJsonEncoder< ValueEncoder >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAlias : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyAlias.JsonEncoder.Value, ValueAlias.JsonEncoder.Value > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
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
