//
//  KindKitJson
//

import Foundation
import KindKitCore

public extension Json {
    
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type) throws -> DecoderType.ValueType {
        return try decoder.decode(try self._get(path: nil))
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type) throws -> DecoderType.ModelType {
        return try self.decode(ModelJsonDecoder< DecoderType >.self)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type) throws -> AliasType.JsonDecoderType.ValueType {
        return try self.decode(AliasType.JsonDecoderType.self)
    }
    
}

public extension Json {
    
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type, default: DecoderType.ValueType) -> DecoderType.ValueType {
        return (try? decoder.decode(try self._get(path: nil))) ?? `default`
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type, default: DecoderType.ModelType) -> DecoderType.ModelType {
        return self.decode(ModelJsonDecoder< DecoderType >.self, default: `default`)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type, default: AliasType.JsonDecoderType.ValueType) -> AliasType.JsonDecoderType.ValueType {
        return self.decode(AliasType.JsonDecoderType.self, default: `default`)
    }
    
}

public extension Json {
    
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type, skipping: Bool = false) throws -> Array< DecoderType.ValueType > {
        guard let jsonArray = try self._get(path: nil) as? NSArray else { throw JsonError.cast }
        var result: [DecoderType.ValueType] = []
        if skipping == true {
            for jsonItem in jsonArray {
                guard let value = try? decoder.decode(jsonItem as! IJsonValue) else { continue }
                result.append(value)
            }
        } else {
            for jsonItem in jsonArray {
                result.append(try decoder.decode(jsonItem as! IJsonValue))
            }
        }
        return result
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type, skipping: Bool = false) throws -> Array< DecoderType.ModelType > {
        return try self.decode(ModelJsonDecoder< DecoderType >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type, skipping: Bool = false) throws -> Array< AliasType.JsonDecoderType.ValueType > {
        return try self.decode(AliasType.JsonDecoderType.self, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type, default: Array< DecoderType.ValueType >, skipping: Bool = false) -> Array< DecoderType.ValueType > {
        return (try? self.decode(decoder, skipping: skipping) as Array< DecoderType.ValueType >) ?? `default`
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type, default: Array< DecoderType.ModelType >, skipping: Bool = false) -> Array< DecoderType.ModelType > {
        return self.decode(ModelJsonDecoder< DecoderType >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type, default: Array< AliasType.JsonDecoderType.ValueType >, skipping: Bool = false) -> Array< AliasType.JsonDecoderType.ValueType > {
        return self.decode(AliasType.JsonDecoderType.self, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType > {
        guard let jsonDictionary = try self._get(path: nil) as? NSDictionary else { throw JsonError.cast }
        var result: [KeyDecoderType.ValueType : ValueDecoderType.ValueType] = [:]
        if skipping == true {
            for jsonItem in jsonDictionary {
                let key = try keyDecoder.decode(jsonItem.key as! IJsonValue)
                guard let value = try? valueDecoder.decode(jsonItem.value as! IJsonValue) else { continue }
                result[key] = value
            }
        } else {
            for jsonItem in jsonDictionary {
                let key = try keyDecoder.decode(jsonItem.key as! IJsonValue)
                let value = try valueDecoder.decode(jsonItem.value as! IJsonValue)
                result[key] = value
            }
        }
        return result
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ModelType > {
        return try self.decode(keyDecoder, ModelJsonDecoder< ValueDecoderType >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return try self.decode(keyDecoder, ValueAlias.JsonDecoderType.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ValueType > {
        return try self.decode(ModelJsonDecoder< KeyDecoderType >.self, valueDecoder, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ModelType > {
        return try self.decode(ModelJsonDecoder< KeyDecoderType >.self, ModelJsonDecoder< ValueDecoderType >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ModelType, ValueAlias.JsonDecoderType.ValueType > {
        return try self.decode(ModelJsonDecoder< KeyDecoderType >.self, ValueAlias.JsonDecoderType.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonValueDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, skipping: Bool = false) throws -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ValueType > {
        return try self.decode(KeyAliasType.JsonDecoderType.self, valueDecoder.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonModelDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, skipping: Bool = false) throws -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ModelType > {
        return try self.decode(KeyAliasType.JsonDecoderType.self, ModelJsonDecoder< ValueDecoderType >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAliasType.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return try self.decode(KeyAliasType.JsonDecoderType.self, ValueAlias.JsonDecoderType.self, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, default: Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType > {
        return (try? self.decode(keyDecoder, valueDecoder, skipping: skipping) as Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType >) ?? `default`
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, default: Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ModelType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ModelType > {
        return self.decode(keyDecoder, ModelJsonDecoder< ValueDecoderType >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, default: Dictionary< KeyDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return self.decode(keyDecoder, ValueAlias.JsonDecoderType.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, default: Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ValueType > {
        return self.decode(ModelJsonDecoder< KeyDecoderType >.self, valueDecoder, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, default: Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ModelType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ModelType > {
        return self.decode(ModelJsonDecoder< KeyDecoderType >.self, ModelJsonDecoder< ValueDecoderType >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, default: Dictionary< KeyDecoderType.ModelType, ValueAlias.JsonDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ModelType, ValueAlias.JsonDecoderType.ValueType > {
        return self.decode(ModelJsonDecoder< KeyDecoderType >.self, ValueAlias.JsonDecoderType.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonValueDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, default: Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ValueType > {
        return self.decode(KeyAliasType.JsonDecoderType.self, valueDecoder.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonModelDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, default: Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ModelType >, skipping: Bool = false) -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ModelType > {
        return self.decode(KeyAliasType.JsonDecoderType.self, ModelJsonDecoder< ValueDecoderType >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAliasType.Type, _ valueAlias: ValueAlias.Type, default: Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return self.decode(KeyAliasType.JsonDecoderType.self, ValueAlias.JsonDecoderType.self, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type, path: String) throws -> DecoderType.ValueType {
        return try decoder.decode(try self._get(path: path))
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type, path: String) throws -> DecoderType.ModelType {
        return try self.decode(ModelJsonDecoder< DecoderType >.self, path: path)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type, path: String) throws -> AliasType.JsonDecoderType.ValueType {
        return try self.decode(AliasType.JsonDecoderType.self, path: path)
    }
    
}

public extension Json {
    
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type, path: String, default: DecoderType.ValueType) -> DecoderType.ValueType {
        return (try? decoder.decode(try self._get(path: path))) ?? `default`
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type, path: String, default: DecoderType.ModelType) -> DecoderType.ModelType {
        return self.decode(ModelJsonDecoder< DecoderType >.self, path: path, default: `default`)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type, path: String, default: AliasType.JsonDecoderType.ValueType) -> AliasType.JsonDecoderType.ValueType {
        return self.decode(AliasType.JsonDecoderType.self, path: path, default: `default`)
    }
    
}

public extension Json {
    
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type, path: String, skipping: Bool = false) throws -> Array< DecoderType.ValueType > {
        guard let jsonArray = try self._get(path: path) as? NSArray else { throw JsonError.cast }
        var result: [DecoderType.ValueType] = []
        if skipping == true {
            for jsonItem in jsonArray {
                guard let value = try? decoder.decode(jsonItem as! IJsonValue) else { continue }
                result.append(value)
            }
        } else {
            for jsonItem in jsonArray {
                result.append(try decoder.decode(jsonItem as! IJsonValue))
            }
        }
        return result
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type, path: String, skipping: Bool = false) throws -> Array< DecoderType.ModelType > {
        return try self.decode(ModelJsonDecoder< DecoderType >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type, path: String, skipping: Bool = false) throws -> Array< AliasType.JsonDecoderType.ValueType > {
        return try self.decode(AliasType.JsonDecoderType.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< DecoderType : IJsonValueDecoder >(_ decoder: DecoderType.Type, path: String, default: Array< DecoderType.ValueType >, skipping: Bool = false) -> Array< DecoderType.ValueType > {
        return (try? self.decode(decoder, path: path, skipping: skipping) as Array< DecoderType.ValueType >) ?? `default`
    }
    
    @inlinable
    func decode< DecoderType : IJsonModelDecoder >(_ decoder: DecoderType.Type, path: String, default: Array< DecoderType.ModelType >, skipping: Bool = false) -> Array< DecoderType.ModelType > {
        return self.decode(ModelJsonDecoder< DecoderType >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< AliasType : IJsonDecoderAlias >(_ alias: AliasType.Type, path: String, default: Array< AliasType.JsonDecoderType.ValueType >, skipping: Bool = false) -> Array< AliasType.JsonDecoderType.ValueType > {
        return self.decode(AliasType.JsonDecoderType.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType > {
        guard let jsonDictionary = try self._get(path: path) as? NSDictionary else { throw JsonError.cast }
        var result: [KeyDecoderType.ValueType : ValueDecoderType.ValueType] = [:]
        if skipping == true {
            for jsonItem in jsonDictionary {
                let key = try keyDecoder.decode(jsonItem.key as! IJsonValue)
                guard let value = try? valueDecoder.decode(jsonItem.value as! IJsonValue) else { continue }
                result[key] = value
            }
        } else {
            for jsonItem in jsonDictionary {
                let key = try keyDecoder.decode(jsonItem.key as! IJsonValue)
                let value = try valueDecoder.decode(jsonItem.value as! IJsonValue)
                result[key] = value
            }
        }
        return result
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ModelType > {
        return try self.decode(keyDecoder, ModelJsonDecoder< ValueDecoderType >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return try self.decode(keyDecoder, ValueAlias.JsonDecoderType.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ValueType > {
        return try self.decode(ModelJsonDecoder< KeyDecoderType >.self, valueDecoder, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ModelType > {
        return try self.decode(ModelJsonDecoder< KeyDecoderType >.self, ModelJsonDecoder< ValueDecoderType >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoderType.ModelType, ValueAlias.JsonDecoderType.ValueType > {
        return try self.decode(ModelJsonDecoder< KeyDecoderType >.self, ValueAlias.JsonDecoderType.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonValueDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ValueType > {
        return try self.decode(KeyAliasType.JsonDecoderType.self, valueDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonModelDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ModelType > {
        return try self.decode(KeyAliasType.JsonDecoderType.self, ModelJsonDecoder< ValueDecoderType >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAliasType.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return try self.decode(KeyAliasType.JsonDecoderType.self, ValueAlias.JsonDecoderType.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, default: Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType > {
        return (try? self.decode(keyDecoder, valueDecoder, path: path, skipping: skipping) as Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ValueType >) ?? `default`
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, default: Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ModelType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ValueType, ValueDecoderType.ModelType > {
        return self.decode(keyDecoder, ModelJsonDecoder< ValueDecoderType >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, path: String, default: Dictionary< KeyDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return self.decode(keyDecoder, ValueAlias.JsonDecoderType.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonValueDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, default: Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ValueType > {
        return self.decode(ModelJsonDecoder< KeyDecoderType >.self, valueDecoder, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueDecoderType : IJsonModelDecoder >(_ keyDecoder: KeyDecoderType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, default: Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ModelType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ModelType, ValueDecoderType.ModelType > {
        return self.decode(ModelJsonDecoder< KeyDecoderType >.self, ModelJsonDecoder< ValueDecoderType >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoderType : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoderType.Type, _ valueAlias: ValueAlias.Type, path: String, default: Dictionary< KeyDecoderType.ModelType, ValueAlias.JsonDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyDecoderType.ModelType, ValueAlias.JsonDecoderType.ValueType > {
        return self.decode(ModelJsonDecoder< KeyDecoderType >.self, ValueAlias.JsonDecoderType.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonValueDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, default: Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ValueType > {
        return self.decode(KeyAliasType.JsonDecoderType.self, valueDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueDecoderType : IJsonModelDecoder >(_ keyAlias: KeyAliasType.Type, _ valueDecoder: ValueDecoderType.Type, path: String, default: Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ModelType >, skipping: Bool = false) -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueDecoderType.ModelType > {
        return self.decode(KeyAliasType.JsonDecoderType.self, ModelJsonDecoder< ValueDecoderType >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAliasType : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAliasType.Type, _ valueAlias: ValueAlias.Type, path: String, default: Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType >, skipping: Bool = false) -> Dictionary< KeyAliasType.JsonDecoderType.ValueType, ValueAlias.JsonDecoderType.ValueType > {
        return self.decode(KeyAliasType.JsonDecoderType.self, ValueAlias.JsonDecoderType.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode(_ dateFormat: String, path: String) throws -> Date {
        let string = try self.decode(StringJsonCoder.self, path: path) as String
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: string) else { throw JsonError.cast }
        return date
    }
    
}
