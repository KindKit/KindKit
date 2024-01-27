//
//  KindKit
//

public struct DictionaryDecodeOptions< Key : CodingOptions, Value : CodingOptions > : CodingOptions {
    
    public let key: Key
    public let value: Value
    public let sequence: SequenceCodingOptions
    
    fileprivate init(
        key: Key,
        value: Value,
        sequence: SequenceCodingOptions
    ) {
        self.key = key
        self.value = value
        self.sequence = sequence
    }
    
}

extension DictionaryDecodeOptions : DefaultCodingOptions where Key : DefaultCodingOptions, Value : DefaultCodingOptions {
    
    public static var `default`: Self {
        return .init(key: .default, value: .default, sequence: .default)
    }
    
}

public extension DictionaryDecodeOptions {
    
    static func nonEmpty(key: Key, value: Value) -> Self {
        return .init(key: key, value: value, sequence: .nonEmpty)
    }
    
    static func skipInvalid(key: Key, value: Value) -> Self {
        return .init(key: key, value: value, sequence: .skipInvalid)
    }
    
}

public extension DictionaryDecodeOptions where Key : DefaultCodingOptions {
    
    static func nonEmpty(value: Value) -> Self {
        return .init(key: .default, value: value, sequence: .nonEmpty)
    }
    
    static func skipInvalid(value: Value) -> Self {
        return .init(key: .default, value: value, sequence: .skipInvalid)
    }
    
}

public extension DictionaryDecodeOptions where Value : DefaultCodingOptions {
    
    static func nonEmpty(key: Key) -> Self {
        return .init(key: key, value: .default, sequence: .nonEmpty)
    }
    
    static func skipInvalid(key: Key) -> Self {
        return .init(key: key, value: .default, sequence: .skipInvalid)
    }
    
}

public extension DictionaryDecodeOptions where Self : DefaultCodingOptions {
    
    static var nonEmpty: Self {
        return .init(key: .default, value: .default, sequence: .nonEmpty)
    }
    
    static var skipInvalid: Self {
        return .init(key: .default, value: .default, sequence: .skipInvalid)
    }
    
}
