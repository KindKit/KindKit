//
//  KindKitJson
//

import Foundation
import KindKitCore

public extension Json {
    
    func encode< EncoderType: IJsonValueEncoder >(_ encoder: EncoderType.Type, value: EncoderType.ValueType) throws {
        try self._set(value: try encoder.encode(value), path: nil)
    }
    
    @inlinable
    func encode< EncoderType: IJsonModelEncoder >(_ encoder: EncoderType.Type, value: EncoderType.ModelType) throws {
        try self.encode(ModelJsonEncoder< EncoderType >.self, value: value)
    }
    
    @inlinable
    func encode< AliasType: IJsonEncoderAlias >(_ alias: AliasType.Type, value: AliasType.JsonEncoderType.ValueType) throws {
        try self.encode(AliasType.JsonEncoderType.self, value: value)
    }
    
}

public extension Json {
    
    func encode< EncoderType: IJsonValueEncoder >(_ encoder: EncoderType.Type, value: EncoderType.ValueType, path: String) throws {
        try self._set(value: try encoder.encode(value), path: path)
    }
    
    @inlinable
    func encode< EncoderType: IJsonModelEncoder >(_ encoder: EncoderType.Type, value: EncoderType.ModelType, path: String) throws {
        try self.encode(ModelJsonEncoder< EncoderType >.self, value: value, path: path)
    }
    
    @inlinable
    func encode< AliasType: IJsonEncoderAlias >(_ alias: AliasType.Type, value: AliasType.JsonEncoderType.ValueType, path: String) throws {
        try self.encode(AliasType.JsonEncoderType.self, value: value, path: path)
    }
    
}

public extension Json {
    
    func encode< EncoderType : IJsonValueEncoder >(_ encoder: EncoderType.Type, value: Array< EncoderType.ValueType >, skipping: Bool = false) throws {
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
    func encode< EncoderType : IJsonModelEncoder >(_ encoder: EncoderType.Type, value: Array< EncoderType.ModelType >, skipping: Bool = false) throws {
        try self.encode(ModelJsonEncoder< EncoderType >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< AliasType : IJsonEncoderAlias >(_ alias: AliasType.Type, value: Array< AliasType.JsonEncoderType.ValueType >, skipping: Bool = false) throws {
        return try self.encode(AliasType.JsonEncoderType.self, value: value, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< KeyEncoderType : IJsonValueEncoder, ValueEncoderType : IJsonValueEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ValueType, ValueEncoderType.ValueType >, skipping: Bool = false) throws {
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
    func encode< KeyEncoderType : IJsonValueEncoder, ValueEncoderType : IJsonModelEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ValueType, ValueEncoderType.ModelType >, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ModelJsonEncoder< ValueEncoderType >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoderType.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoderType.ValueType, ValueAlias.JsonEncoderType.ValueType >, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ValueAlias.JsonEncoderType.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueEncoderType : IJsonValueEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ModelType, ValueEncoderType.ValueType >, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoderType >.self, valueEncoder, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueEncoderType : IJsonModelEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ModelType, ValueEncoderType.ModelType >, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoderType >.self, ModelJsonEncoder< ValueEncoderType >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoderType.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoderType.ModelType, ValueAlias.JsonEncoderType.ValueType >, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoderType >.self, ValueAlias.JsonEncoderType.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueEncoderType : IJsonValueEncoder >(_ keyAlias: KeyAliasType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueEncoderType.ValueType >, skipping: Bool = false) throws {
        return try self.encode(KeyAliasType.JsonEncoderType.self, valueEncoder.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueEncoderType : IJsonModelEncoder >(_ keyAlias: KeyAliasType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueEncoderType.ModelType >, skipping: Bool = false) throws {
        return try self.encode(KeyAliasType.JsonEncoderType.self, ModelJsonEncoder< ValueEncoderType >.self, value: value, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAliasType.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueAlias.JsonEncoderType.ValueType >, skipping: Bool = false) throws {
        return try self.encode(KeyAliasType.JsonEncoderType.self, ValueAlias.JsonEncoderType.self, value: value, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< EncoderType: IJsonValueEncoder >(_ encoder: EncoderType.Type, value: Optional< EncoderType.ValueType >, path: String, nullable: Bool = false) throws {
        if let value = value {
            try self._set(value: try encoder.encode(value), path: path)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< EncoderType: IJsonModelEncoder >(_ encoder: EncoderType.Type, value: Optional< EncoderType.ModelType >, path: String, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< EncoderType >.self, value: value, path: path, nullable: nullable)
    }
    
    @inlinable
    func encode< AliasType: IJsonEncoderAlias >(_ alias: AliasType.Type, value: Optional< AliasType.JsonEncoderType.ValueType >, path: String, nullable: Bool = false) throws {
        try self.encode(AliasType.JsonEncoderType.self, value: value, path: path, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode< EncoderType : IJsonValueEncoder >(_ encoder: EncoderType.Type, value: Array< EncoderType.ValueType >, path: String, skipping: Bool = false) throws {
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
    func encode< EncoderType : IJsonModelEncoder >(_ encoder: EncoderType.Type, value: Array< EncoderType.ModelType >, path: String, skipping: Bool = false) throws {
        try self.encode(ModelJsonEncoder< EncoderType >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< AliasType : IJsonEncoderAlias >(_ alias: AliasType.Type, value: Array< AliasType.JsonEncoderType.ValueType >, path: String, skipping: Bool = false) throws {
        return try self.encode(AliasType.JsonEncoderType.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< EncoderType : IJsonValueEncoder >(_ encoder: EncoderType.Type, value: Optional< Array< EncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        if let value = value {
            try self.encode(encoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< EncoderType : IJsonModelEncoder >(_ encoder: EncoderType.Type, value: Optional< Array< EncoderType.ModelType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< EncoderType >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< AliasType : IJsonEncoderAlias >(_ alias: AliasType.Type, value: Optional< Array< AliasType.JsonEncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        return try self.encode(AliasType.JsonEncoderType.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode< KeyEncoderType : IJsonValueEncoder, ValueEncoderType : IJsonValueEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ValueType, ValueEncoderType.ValueType >, path: String, skipping: Bool = false) throws {
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
    func encode< KeyEncoderType : IJsonValueEncoder, ValueEncoderType : IJsonModelEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ValueType, ValueEncoderType.ModelType >, path: String, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ModelJsonEncoder< ValueEncoderType >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoderType.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoderType.ValueType, ValueAlias.JsonEncoderType.ValueType >, path: String, skipping: Bool = false) throws {
        return try self.encode(keyEncoder, ValueAlias.JsonEncoderType.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueEncoderType : IJsonValueEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ModelType, ValueEncoderType.ValueType >, path: String, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoderType >.self, valueEncoder, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueEncoderType : IJsonModelEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyEncoderType.ModelType, ValueEncoderType.ModelType >, path: String, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoderType >.self, ModelJsonEncoder< ValueEncoderType >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoderType.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyEncoderType.ModelType, ValueAlias.JsonEncoderType.ValueType >, path: String, skipping: Bool = false) throws {
        return try self.encode(ModelJsonEncoder< KeyEncoderType >.self, ValueAlias.JsonEncoderType.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueEncoderType : IJsonValueEncoder >(_ keyAlias: KeyAliasType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueEncoderType.ValueType >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAliasType.JsonEncoderType.self, valueEncoder.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueEncoderType : IJsonModelEncoder >(_ keyAlias: KeyAliasType.Type, _ valueEncoder: ValueEncoderType.Type, value: Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueEncoderType.ModelType >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAliasType.JsonEncoderType.self, ModelJsonEncoder< ValueEncoderType >.self, value: value, path: path, skipping: skipping)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAliasType.Type, _ valueAlias: ValueAlias.Type, value: Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueAlias.JsonEncoderType.ValueType >, path: String, skipping: Bool = false) throws {
        return try self.encode(KeyAliasType.JsonEncoderType.self, ValueAlias.JsonEncoderType.self, value: value, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    func encode< KeyEncoderType : IJsonValueEncoder, ValueEncoderType : IJsonValueEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Optional< Dictionary< KeyEncoderType.ValueType, ValueEncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        if let value = value {
            try self.encode(keyEncoder, valueEncoder, value: value, path: path, skipping: skipping)
        } else if nullable == true {
            try self._set(value: NSNull(), path: path)
        }
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonValueEncoder, ValueEncoderType : IJsonModelEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Optional< Dictionary< KeyEncoderType.ValueType, ValueEncoderType.ModelType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(keyEncoder, ModelJsonEncoder< ValueEncoderType >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonValueEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoderType.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyEncoderType.ValueType, ValueAlias.JsonEncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(keyEncoder, ValueAlias.JsonEncoderType.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueEncoderType : IJsonValueEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Optional< Dictionary< KeyEncoderType.ModelType, ValueEncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< KeyEncoderType >.self, valueEncoder, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueEncoderType : IJsonModelEncoder >(_ keyEncoder: KeyEncoderType.Type, _ valueEncoder: ValueEncoderType.Type, value: Optional< Dictionary< KeyEncoderType.ModelType, ValueEncoderType.ModelType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< KeyEncoderType >.self, ModelJsonEncoder< ValueEncoderType >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyEncoderType : IJsonModelEncoder, ValueAlias : IJsonEncoderAlias >(_ keyEncoder: KeyEncoderType.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyEncoderType.ModelType, ValueAlias.JsonEncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(ModelJsonEncoder< KeyEncoderType >.self, ValueAlias.JsonEncoderType.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueEncoderType : IJsonValueEncoder >(_ keyAlias: KeyAliasType.Type, _ valueEncoder: ValueEncoderType.Type, value: Optional< Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueEncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAliasType.JsonEncoderType.self, valueEncoder.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueEncoderType : IJsonModelEncoder >(_ keyAlias: KeyAliasType.Type, _ valueEncoder: ValueEncoderType.Type, value: Optional< Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueEncoderType.ModelType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAliasType.JsonEncoderType.self, ModelJsonEncoder< ValueEncoderType >.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
    @inlinable
    func encode< KeyAliasType : IJsonEncoderAlias, ValueAlias : IJsonEncoderAlias >(_ keyAlias: KeyAliasType.Type, _ valueAlias: ValueAlias.Type, value: Optional< Dictionary< KeyAliasType.JsonEncoderType.ValueType, ValueAlias.JsonEncoderType.ValueType > >, path: String, skipping: Bool = false, nullable: Bool = false) throws {
        try self.encode(KeyAliasType.JsonEncoderType.self, ValueAlias.JsonEncoderType.self, value: value, path: path, skipping: skipping, nullable: nullable)
    }
    
}

public extension Json {
    
    func encode(_ dateFormat: String, value: Date, path: String) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        try self.encode(String.self, value: formatter.string(from: value))
    }
    
}
