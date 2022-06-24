//
//  KindKitJson
//

import Foundation
import KindKitCore

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type) throws -> Decoder.Value {
        return try decoder.decode(try self._get(path: nil))
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type) throws -> Decoder.Model {
        return try self.decode(ModelJsonDecoder< Decoder >.self)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type) throws -> Alias.JsonDecoder.Value {
        return try self.decode(Alias.JsonDecoder.self)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, default: Decoder.Value) -> Decoder.Value {
        return (try? decoder.decode(try self._get(path: nil))) ?? `default`
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, default: Decoder.Model) -> Decoder.Model {
        return self.decode(ModelJsonDecoder< Decoder >.self, default: `default`)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, default: Alias.JsonDecoder.Value) -> Alias.JsonDecoder.Value {
        return self.decode(Alias.JsonDecoder.self, default: `default`)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, skipping: Bool = false) throws -> Array< Decoder.Value > {
        guard let jsonArray = try self._get(path: nil) as? NSArray else { throw JsonError.cast }
        var result: [Decoder.Value] = []
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
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, skipping: Bool = false) throws -> Array< Decoder.Model > {
        return try self.decode(ModelJsonDecoder< Decoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, skipping: Bool = false) throws -> Array< Alias.JsonDecoder.Value > {
        return try self.decode(Alias.JsonDecoder.self, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, default: Array< Decoder.Value >, skipping: Bool = false) -> Array< Decoder.Value > {
        return (try? self.decode(decoder, skipping: skipping) as Array< Decoder.Value >) ?? `default`
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, default: Array< Decoder.Model >, skipping: Bool = false) -> Array< Decoder.Model > {
        return self.decode(ModelJsonDecoder< Decoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, default: Array< Alias.JsonDecoder.Value >, skipping: Bool = false) -> Array< Alias.JsonDecoder.Value > {
        return self.decode(Alias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Value, ValueDecoder.Value > {
        guard let jsonDictionary = try self._get(path: nil) as? NSDictionary else { throw JsonError.cast }
        var result: [KeyDecoder.Value : ValueDecoder.Value] = [:]
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
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Value, ValueDecoder.Model > {
        return try self.decode(keyDecoder, ModelJsonDecoder< ValueDecoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return try self.decode(keyDecoder, ValueAlias.JsonDecoder.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Model, ValueDecoder.Value > {
        return try self.decode(ModelJsonDecoder< KeyDecoder >.self, valueDecoder, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Model, ValueDecoder.Model > {
        return try self.decode(ModelJsonDecoder< KeyDecoder >.self, ModelJsonDecoder< ValueDecoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Model, ValueAlias.JsonDecoder.Value > {
        return try self.decode(ModelJsonDecoder< KeyDecoder >.self, ValueAlias.JsonDecoder.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Value > {
        return try self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Model > {
        return try self.decode(KeyAlias.JsonDecoder.self, ModelJsonDecoder< ValueDecoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> Dictionary< KeyAlias.JsonDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return try self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: Dictionary< KeyDecoder.Value, ValueDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Value, ValueDecoder.Value > {
        return (try? self.decode(keyDecoder, valueDecoder, skipping: skipping) as Dictionary< KeyDecoder.Value, ValueDecoder.Value >) ?? `default`
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: Dictionary< KeyDecoder.Value, ValueDecoder.Model >, skipping: Bool = false) -> Dictionary< KeyDecoder.Value, ValueDecoder.Model > {
        return self.decode(keyDecoder, ModelJsonDecoder< ValueDecoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, default: Dictionary< KeyDecoder.Value, ValueAlias.JsonDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return self.decode(keyDecoder, ValueAlias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: Dictionary< KeyDecoder.Model, ValueDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Model, ValueDecoder.Value > {
        return self.decode(ModelJsonDecoder< KeyDecoder >.self, valueDecoder, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: Dictionary< KeyDecoder.Model, ValueDecoder.Model >, skipping: Bool = false) -> Dictionary< KeyDecoder.Model, ValueDecoder.Model > {
        return self.decode(ModelJsonDecoder< KeyDecoder >.self, ModelJsonDecoder< ValueDecoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, default: Dictionary< KeyDecoder.Model, ValueAlias.JsonDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Model, ValueAlias.JsonDecoder.Value > {
        return self.decode(ModelJsonDecoder< KeyDecoder >.self, ValueAlias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, default: Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Value > {
        return self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, default: Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Model >, skipping: Bool = false) -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Model > {
        return self.decode(KeyAlias.JsonDecoder.self, ModelJsonDecoder< ValueDecoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, default: Dictionary< KeyAlias.JsonDecoder.Value, ValueAlias.JsonDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyAlias.JsonDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String) throws -> Decoder.Value {
        return try decoder.decode(try self._get(path: path))
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String) throws -> Decoder.Model {
        return try self.decode(ModelJsonDecoder< Decoder >.self, path: path)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String) throws -> Alias.JsonDecoder.Value {
        return try self.decode(Alias.JsonDecoder.self, path: path)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String, default: Decoder.Value) -> Decoder.Value {
        return (try? decoder.decode(try self._get(path: path))) ?? `default`
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String, default: Decoder.Model) -> Decoder.Model {
        return self.decode(ModelJsonDecoder< Decoder >.self, path: path, default: `default`)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String, default: Alias.JsonDecoder.Value) -> Alias.JsonDecoder.Value {
        return self.decode(Alias.JsonDecoder.self, path: path, default: `default`)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String, skipping: Bool = false) throws -> Array< Decoder.Value > {
        guard let jsonArray = try self._get(path: path) as? NSArray else { throw JsonError.cast }
        var result: [Decoder.Value] = []
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
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String, skipping: Bool = false) throws -> Array< Decoder.Model > {
        return try self.decode(ModelJsonDecoder< Decoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String, skipping: Bool = false) throws -> Array< Alias.JsonDecoder.Value > {
        return try self.decode(Alias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String, default: Array< Decoder.Value >, skipping: Bool = false) -> Array< Decoder.Value > {
        return (try? self.decode(decoder, path: path, skipping: skipping) as Array< Decoder.Value >) ?? `default`
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String, default: Array< Decoder.Model >, skipping: Bool = false) -> Array< Decoder.Model > {
        return self.decode(ModelJsonDecoder< Decoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String, default: Array< Alias.JsonDecoder.Value >, skipping: Bool = false) -> Array< Alias.JsonDecoder.Value > {
        return self.decode(Alias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Value, ValueDecoder.Value > {
        guard let jsonDictionary = try self._get(path: path) as? NSDictionary else { throw JsonError.cast }
        var result: [KeyDecoder.Value : ValueDecoder.Value] = [:]
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
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Value, ValueDecoder.Model > {
        return try self.decode(keyDecoder, ModelJsonDecoder< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return try self.decode(keyDecoder, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Model, ValueDecoder.Value > {
        return try self.decode(ModelJsonDecoder< KeyDecoder >.self, valueDecoder, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Model, ValueDecoder.Model > {
        return try self.decode(ModelJsonDecoder< KeyDecoder >.self, ModelJsonDecoder< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyDecoder.Model, ValueAlias.JsonDecoder.Value > {
        return try self.decode(ModelJsonDecoder< KeyDecoder >.self, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Value > {
        return try self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Model > {
        return try self.decode(KeyAlias.JsonDecoder.self, ModelJsonDecoder< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> Dictionary< KeyAlias.JsonDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return try self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: Dictionary< KeyDecoder.Value, ValueDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Value, ValueDecoder.Value > {
        return (try? self.decode(keyDecoder, valueDecoder, path: path, skipping: skipping) as Dictionary< KeyDecoder.Value, ValueDecoder.Value >) ?? `default`
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: Dictionary< KeyDecoder.Value, ValueDecoder.Model >, skipping: Bool = false) -> Dictionary< KeyDecoder.Value, ValueDecoder.Model > {
        return self.decode(keyDecoder, ModelJsonDecoder< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, default: Dictionary< KeyDecoder.Value, ValueAlias.JsonDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return self.decode(keyDecoder, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: Dictionary< KeyDecoder.Model, ValueDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Model, ValueDecoder.Value > {
        return self.decode(ModelJsonDecoder< KeyDecoder >.self, valueDecoder, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: Dictionary< KeyDecoder.Model, ValueDecoder.Model >, skipping: Bool = false) -> Dictionary< KeyDecoder.Model, ValueDecoder.Model > {
        return self.decode(ModelJsonDecoder< KeyDecoder >.self, ModelJsonDecoder< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, default: Dictionary< KeyDecoder.Model, ValueAlias.JsonDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyDecoder.Model, ValueAlias.JsonDecoder.Value > {
        return self.decode(ModelJsonDecoder< KeyDecoder >.self, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Value > {
        return self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Model >, skipping: Bool = false) -> Dictionary< KeyAlias.JsonDecoder.Value, ValueDecoder.Model > {
        return self.decode(KeyAlias.JsonDecoder.self, ModelJsonDecoder< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, path: String, default: Dictionary< KeyAlias.JsonDecoder.Value, ValueAlias.JsonDecoder.Value >, skipping: Bool = false) -> Dictionary< KeyAlias.JsonDecoder.Value, ValueAlias.JsonDecoder.Value > {
        return self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode(_ dateFormat: String, path: String) throws -> Date {
        let string = try self.decode(StringJsonCoder.self, path: path)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: string) else { throw JsonError.cast }
        return date
    }
    
}
