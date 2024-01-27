//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Dictionary : ValueDecoderTrait where Key : ValueDecoderTrait, Value : ValueDecoderTrait, Key.JsonDecoded : Hashable {
    
    public typealias JsonDecoded = Dictionary< Key.JsonDecoded, Value.JsonDecoded >
    public typealias JsonDecodeOptions = DictionaryDecodeOptions< Key.JsonDecodeOptions, Value.JsonDecodeOptions >
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        guard let dictionary = field as? NSDictionary else {
            throw CodingError(in: path)
        }
        var result: [Key.JsonDecoded: Value.JsonDecoded] = [:]
        for item in dictionary {
            do {
                let subPath = path.appending(.key(item.key as! String))
                let key = try Key.json(decode: item.key as! Field, in: subPath, with: options.key)
                result[key] = try Value.json(decode: item.value as! Field, in: subPath, with: options.value)
            } catch let error {
                if options.sequence.contains(.skipInvalid) == true {
                    continue
                }
                throw error
            }
        }
        if options.sequence.contains(.nonEmpty) == true && result.isEmpty == true {
            throw CodingError(in: path)
        }
        return result
    }
    
}

extension Dictionary : ValueEncoderTrait where Key : ValueEncoderTrait, Value : ValueEncoderTrait, Key.JsonEncoded : Hashable {
    
    public typealias JsonEncoded = Dictionary< Key.JsonEncoded, Value.JsonEncoded >
    public typealias JsonEncodeOptions = DictionaryEncodeOptions< Key.JsonEncodeOptions, Value.JsonEncodeOptions >
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        if options.sequence.contains(.nonEmpty) == true && value.isEmpty == true {
            throw CodingError(in: path)
        }
        let result = NSMutableDictionary(capacity: value.count)
        for item in value {
            do {
                let subPath = path.appending(.key("\(item.key)"))
                let key = try Key.json(encode: item.key, in: subPath, with: options.key)
                let value = try Value.json(encode: item.value, in: subPath, with: options.value)
                if let key = key, let value = value {
                    result.setObject(value, forKey: key as! NSCopying)
                }
            } catch let error {
                if options.sequence.contains(.skipInvalid) == true {
                    continue
                }
                throw error
            }
        }
        return result
    }
    
}
