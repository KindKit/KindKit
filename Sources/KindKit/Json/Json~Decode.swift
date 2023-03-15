//
//  KindKit
//

import Foundation

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type) throws -> Decoder.JsonDecoded {
        return try decoder.decode(try self._get(path: nil))
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type) throws -> Decoder.JsonModelDecoded {
        return try self.decode(Json.Coder.Model< Decoder >.self)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type) throws -> Alias.JsonDecoder.JsonDecoded {
        return try self.decode(Alias.JsonDecoder.self)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, default: Decoder.JsonDecoded) -> Decoder.JsonDecoded {
        guard let result = try? decoder.decode(try self._get(path: nil)) else { return `default` }
        return result
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, default: Decoder.JsonModelDecoded) -> Decoder.JsonModelDecoded {
        return self.decode(Json.Coder.Model< Decoder >.self, default: `default`)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, default: Alias.JsonDecoder.JsonDecoded) -> Alias.JsonDecoder.JsonDecoded {
        return self.decode(Alias.JsonDecoder.self, default: `default`)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, skipping: Bool = false) throws -> [Decoder.JsonDecoded] {
        guard let jsonArray = try self._get(path: nil) as? NSArray else {
            throw Json.Error.cast
        }
        var result: [Decoder.JsonDecoded] = []
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
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, skipping: Bool = false) throws -> [Decoder.JsonModelDecoded] {
        return try self.decode(Json.Coder.Model< Decoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, skipping: Bool = false) throws -> [Alias.JsonDecoder.JsonDecoded] {
        return try self.decode(Alias.JsonDecoder.self, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, default: [Decoder.JsonDecoded], skipping: Bool = false) -> [Decoder.JsonDecoded] {
        guard let result = try? self.decode(decoder, skipping: skipping) else { return `default` }
        return result
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, default: [Decoder.JsonModelDecoded], skipping: Bool = false) -> [Decoder.JsonModelDecoded] {
        return self.decode(Json.Coder.Model< Decoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, default: [Alias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [Alias.JsonDecoder.JsonDecoded] {
        return self.decode(Alias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        guard let jsonDictionary = try self._get(path: nil) as? NSDictionary else {
            throw Json.Error.cast
        }
        var result: [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] = [:]
        if skipping == true {
            for jsonItem in jsonDictionary {
                guard let key = try? keyDecoder.decode(jsonItem.key as! IJsonValue) else { continue }
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
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(keyDecoder, Json.Coder.Model< ValueDecoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(keyDecoder, ValueAlias.JsonDecoder.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, valueDecoder, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, Json.Coder.Model< ValueDecoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, ValueAlias.JsonDecoder.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, skipping: Bool = false) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, Json.Coder.Model< ValueDecoder >.self, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, skipping: Bool = false) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        guard let result = try? self.decode(keyDecoder, valueDecoder, skipping: skipping) else { return `default` }
        return result
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded], skipping: Bool = false) -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(keyDecoder, Json.Coder.Model< ValueDecoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, default: [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(keyDecoder, ValueAlias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, valueDecoder, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, default: [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded], skipping: Bool = false) -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, Json.Coder.Model< ValueDecoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, default: [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, ValueAlias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, default: [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded], skipping: Bool = false) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, default: [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded], skipping: Bool = false) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, Json.Coder.Model< ValueDecoder >.self, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, default: [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String) throws -> Decoder.JsonDecoded {
        return try decoder.decode(try self._get(path: path))
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String) throws -> Decoder.JsonModelDecoded {
        return try self.decode(Json.Coder.Model< Decoder >.self, path: path)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String) throws -> Alias.JsonDecoder.JsonDecoded {
        return try self.decode(Alias.JsonDecoder.self, path: path)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String, default: Decoder.JsonDecoded) -> Decoder.JsonDecoded {
        guard let result = try? decoder.decode(try self._get(path: path)) else { return `default` }
        return result
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String, default: Decoder.JsonModelDecoded) -> Decoder.JsonModelDecoded {
        return self.decode(Json.Coder.Model< Decoder >.self, path: path, default: `default`)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String, default: Alias.JsonDecoder.JsonDecoded) -> Alias.JsonDecoder.JsonDecoded {
        return self.decode(Alias.JsonDecoder.self, path: path, default: `default`)
    }
    
}

public extension Json {
    
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String, skipping: Bool = false) throws -> [Decoder.JsonDecoded] {
        guard let jsonArray = try self._get(path: path) as? NSArray else {
            throw Json.Error.cast
        }
        var result: [Decoder.JsonDecoded] = []
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
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String, skipping: Bool = false) throws -> [Decoder.JsonModelDecoded] {
        return try self.decode(Json.Coder.Model< Decoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String, skipping: Bool = false) throws -> [Alias.JsonDecoder.JsonDecoded] {
        return try self.decode(Alias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< Decoder : IJsonValueDecoder >(_ decoder: Decoder.Type, path: String, default: [Decoder.JsonDecoded], skipping: Bool = false) -> [Decoder.JsonDecoded] {
        return (try? self.decode(decoder, path: path, skipping: skipping) as [Decoder.JsonDecoded]) ?? `default`
    }
    
    @inlinable
    func decode< Decoder : IJsonModelDecoder >(_ decoder: Decoder.Type, path: String, default: [Decoder.JsonModelDecoded], skipping: Bool = false) -> [Decoder.JsonModelDecoded] {
        return self.decode(Json.Coder.Model< Decoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< Alias : IJsonDecoderAlias >(_ alias: Alias.Type, path: String, default: [Alias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [Alias.JsonDecoder.JsonDecoded] {
        return self.decode(Alias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        guard let jsonDictionary = try self._get(path: path) as? NSDictionary else {
            throw Json.Error.cast
        }
        var result: [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] = [:]
        if skipping == true {
            for jsonItem in jsonDictionary {
                guard let key = try? keyDecoder.decode(jsonItem.key as! IJsonValue) else { continue }
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
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(keyDecoder, Json.Coder.Model< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(keyDecoder, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, valueDecoder, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, Json.Coder.Model< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, skipping: Bool = false) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, Json.Coder.Model< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, path: String, skipping: Bool = false) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return (try? self.decode(keyDecoder, valueDecoder, path: path, skipping: skipping) as [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded]) ?? `default`
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded], skipping: Bool = false) -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(keyDecoder, Json.Coder.Model< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonValueDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, default: [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(keyDecoder, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonValueDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, valueDecoder, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueDecoder : IJsonModelDecoder >(_ keyDecoder: KeyDecoder.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded], skipping: Bool = false) -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, Json.Coder.Model< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyDecoder : IJsonModelDecoder, ValueAlias : IJsonDecoderAlias >(_ keyDecoder: KeyDecoder.Type, _ valueAlias: ValueAlias.Type, path: String, default: [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonValueDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded], skipping: Bool = false) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueDecoder : IJsonModelDecoder >(_ keyAlias: KeyAlias.Type, _ valueDecoder: ValueDecoder.Type, path: String, default: [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded], skipping: Bool = false) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, Json.Coder.Model< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode< KeyAlias : IJsonDecoderAlias, ValueAlias : IJsonDecoderAlias >(_ keyAlias: KeyAlias.Type, _ valueAlias: ValueAlias.Type, path: String, default: [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded], skipping: Bool = false) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode(_ dateFormat: String, path: String) throws -> Date {
        let string = try self.decode(Json.Coder.String.self, path: path)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: string) else {
            throw Json.Error.cast
        }
        return date
    }
    
}
