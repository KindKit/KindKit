//
//  KindKit
//

import Foundation

public extension Json {
    
    @inlinable
    func decode<
        Decoder : IJsonValueDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root
    ) throws -> Decoder.JsonDecoded {
        return try self.get(
            path: path,
            decode: { value, path in
                try decoder.decode(value, path: path)
            }
        )
    }
    
    @inlinable
    func decode<
        Decoder : IJsonModelDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root
    ) throws -> Decoder.JsonModelDecoded {
        return try self.decode(Json.Coder.Model< Decoder >.self, path: path)
    }
    
    @inlinable
    func decode<
        Alias : IJsonDecoderAlias
    >(
        _ alias: Alias.Type,
        path: Json.Path = .root
    ) throws -> Alias.JsonDecoder.JsonDecoded {
        return try self.decode(Alias.JsonDecoder.self, path: path)
    }
    
}

public extension Json {
    
    @inlinable
    func decode<
        Decoder : IJsonValueDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root,
        default: Decoder.JsonDecoded
    ) -> Decoder.JsonDecoded {
        guard let result = try? self.decode(decoder, path: path) else { return `default` }
        return result
    }
    
    @inlinable
    func decode<
        Decoder : IJsonModelDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root,
        default: Decoder.JsonModelDecoded
    ) -> Decoder.JsonModelDecoded {
        return self.decode(Json.Coder.Model< Decoder >.self, path: path, default: `default`)
    }
    
    @inlinable
    func decode<
        Alias : IJsonDecoderAlias
    >(
        _ alias: Alias.Type,
        path: Json.Path = .root,
        default: Alias.JsonDecoder.JsonDecoded
    ) -> Alias.JsonDecoder.JsonDecoded {
        return self.decode(Alias.JsonDecoder.self, path: path, default: `default`)
    }
    
}

public extension Json {
    
    @inlinable
    func decode<
        Decoder : IJsonValueDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [Decoder.JsonDecoded] {
        return try self.get(
            path: path,
            as: NSArray.self,
            decode: { input, path in
                var result: [Decoder.JsonDecoded] = []
                if skipping == true {
                    for index in 0 ..< input.count {
                        let inputItem = input[index] as! IJsonValue
                        let subPath = path.appending(.index(index))
                        guard let decoded = try? decoder.decode(inputItem, path: subPath) else {
                            continue
                        }
                        result.append(decoded)
                    }
                } else {
                    for index in 0 ..< input.count {
                        let inputItem = input[index] as! IJsonValue
                        let subPath = path.appending(.index(index))
                        let decoded = try decoder.decode(inputItem, path: subPath)
                        result.append(decoded)
                    }
                }
                return result
            }
        )
    }
    
    @inlinable
    func decode<
        Decoder : IJsonModelDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [Decoder.JsonModelDecoded] {
        return try self.decode(Json.Coder.Model< Decoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        Alias : IJsonDecoderAlias
    >(
        _ alias: Alias.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [Alias.JsonDecoder.JsonDecoded] {
        return try self.decode(Alias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode<
        Decoder : IJsonValueDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root,
        default: [Decoder.JsonDecoded],
        skipping: Bool = false
    ) -> [Decoder.JsonDecoded] {
        guard let result = try? self.decode(decoder, path: path, skipping: skipping) else { return `default` }
        return result
    }
    
    @inlinable
    func decode<
        Decoder : IJsonModelDecoder
    >(
        _ decoder: Decoder.Type,
        path: Json.Path = .root,
        default: [Decoder.JsonModelDecoded],
        skipping: Bool = false
    ) -> [Decoder.JsonModelDecoded] {
        return self.decode(Json.Coder.Model< Decoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        Alias : IJsonDecoderAlias
    >(
        _ alias: Alias.Type,
        path: Json.Path = .root,
        default: [Alias.JsonDecoder.JsonDecoded],
        skipping: Bool = false
    ) -> [Alias.JsonDecoder.JsonDecoded] {
        return self.decode(Alias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode<
        KeyDecoder : IJsonValueDecoder,
        ValueDecoder : IJsonValueDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return try self.get(
            path: path,
            as: NSDictionary.self,
            decode: { input, path in
                var result: [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] = [:]
                if skipping == true {
                    for inputItem in input {
                        let inputKey = inputItem.key as! NSString
                        let inputValue = inputItem.value as! IJsonValue
                        let pathItem = Json.Path.Item.key(inputKey as String)
                        let subPath = path.appending(pathItem)
                        guard let decodedKey = try? keyDecoder.decode(inputKey, path: subPath) else {
                            continue
                        }
                        guard let decodedValue = try? valueDecoder.decode(inputValue, path: subPath) else {
                            continue
                        }
                        result[decodedKey] = decodedValue
                    }
                } else {
                    for inputItem in input {
                        let inputKey = inputItem.key as! NSString
                        let inputValue = inputItem.value as! IJsonValue
                        let pathItem = Json.Path.Item.key(inputKey as String)
                        let subPath = path.appending(pathItem)
                        let decodedKey = try keyDecoder.decode(inputKey, path: subPath)
                        let decodedValue = try valueDecoder.decode(inputValue, path: subPath)
                        result[decodedKey] = decodedValue
                    }
                }
                return result
            }
        )
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonValueDecoder,
        ValueDecoder : IJsonModelDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(keyDecoder, Json.Coder.Model< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonValueDecoder,
        ValueAlias : IJsonDecoderAlias
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueAlias: ValueAlias.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(keyDecoder, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonModelDecoder,
        ValueDecoder : IJsonValueDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, valueDecoder, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonModelDecoder,
        ValueDecoder : IJsonModelDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, Json.Coder.Model< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonModelDecoder,
        ValueAlias : IJsonDecoderAlias
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueAlias: ValueAlias.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(Json.Coder.Model< KeyDecoder >.self, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyAlias : IJsonDecoderAlias,
        ValueDecoder : IJsonValueDecoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyAlias : IJsonDecoderAlias,
        ValueDecoder : IJsonModelDecoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, Json.Coder.Model< ValueDecoder >.self, path: path, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyAlias : IJsonDecoderAlias,
        ValueAlias : IJsonDecoderAlias
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueAlias: ValueAlias.Type,
        path: Json.Path = .root,
        skipping: Bool = false
    ) throws -> [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return try self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, path: path, skipping: skipping)
    }
    
}

public extension Json {
    
    @inlinable
    func decode<
        KeyDecoder : IJsonValueDecoder,
        ValueDecoder : IJsonValueDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        default: [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded],
        skipping: Bool = false
    ) -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        guard let result = try? self.decode(keyDecoder, valueDecoder, path: path, skipping: skipping) else { return `default` }
        return result
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonValueDecoder,
        ValueDecoder : IJsonModelDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        default: [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded],
        skipping: Bool = false
    ) -> [KeyDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(keyDecoder, Json.Coder.Model< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonValueDecoder,
        ValueAlias : IJsonDecoderAlias
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueAlias: ValueAlias.Type,
        path: Json.Path = .root,
        default: [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded],
        skipping: Bool = false
    ) -> [KeyDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(keyDecoder, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonModelDecoder,
        ValueDecoder : IJsonValueDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        default: [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded],
        skipping: Bool = false
    ) -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, valueDecoder, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonModelDecoder,
        ValueDecoder : IJsonModelDecoder
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        default: [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded],
        skipping: Bool = false
    ) -> [KeyDecoder.JsonModelDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, Json.Coder.Model< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyDecoder : IJsonModelDecoder,
        ValueAlias : IJsonDecoderAlias
    >(
        _ keyDecoder: KeyDecoder.Type,
        _ valueAlias: ValueAlias.Type,
        path: Json.Path = .root,
        default: [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded],
        skipping: Bool = false
    ) -> [KeyDecoder.JsonModelDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(Json.Coder.Model< KeyDecoder >.self, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyAlias : IJsonDecoderAlias,
        ValueDecoder : IJsonValueDecoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        default: [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded],
        skipping: Bool = false
    ) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, valueDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyAlias : IJsonDecoderAlias,
        ValueDecoder : IJsonModelDecoder
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueDecoder: ValueDecoder.Type,
        path: Json.Path = .root,
        default: [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded],
        skipping: Bool = false
    ) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueDecoder.JsonModelDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, Json.Coder.Model< ValueDecoder >.self, path: path, default: `default`, skipping: skipping)
    }
    
    @inlinable
    func decode<
        KeyAlias : IJsonDecoderAlias,
        ValueAlias : IJsonDecoderAlias
    >(
        _ keyAlias: KeyAlias.Type,
        _ valueAlias: ValueAlias.Type,
        path: Json.Path = .root,
        default: [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded],
        skipping: Bool = false
    ) -> [KeyAlias.JsonDecoder.JsonDecoded : ValueAlias.JsonDecoder.JsonDecoded] {
        return self.decode(KeyAlias.JsonDecoder.self, ValueAlias.JsonDecoder.self, path: path, default: `default`, skipping: skipping)
    }
    
}

public extension Json {
    
    func decode(
        _ dateFormat: String,
        path: Json.Path = .root
    ) throws -> Date {
        return try self.get(
            path: path,
            as: NSString.self,
            decode: { input, path in
                let formatter = DateFormatter()
                formatter.dateFormat = dateFormat
                guard let date = formatter.date(from: input as String) else {
                    throw Json.Error.Coding.cast(path)
                }
                return date
            }
        )
    }
    
    @inlinable
    func decode(
        _ dateFormat: String,
        path: Json.Path = .root,
        default: Date
    ) throws -> Date {
        guard let date = try? self.decode(dateFormat, path: path) else { return `default` }
        return date
    }
    
}

public extension Json {
    
    @inlinable
    func decode<
        Success,
        Failure : Swift.Error
    >(
        success: (Json) throws -> Success,
        failure: (Json) throws -> Failure
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
