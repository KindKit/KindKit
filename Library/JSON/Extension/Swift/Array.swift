//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Array : ValueDecoderTrait where Element : ValueDecoderTrait {
    
    public typealias JsonDecoded = Array< Element.JsonDecoded >
    public typealias JsonDecodeOptions = ArrayDecodeOptions< Element.JsonDecodeOptions >
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        guard let array = field as? NSArray else {
            throw CodingError(in: path)
        }
        var result: [Element.JsonDecoded] = []
        for index in 0 ..< array.count {
            do {
                result.append(try Element.json(decode: array[index] as! Field, in: path.appending(.index(index)), with: options.element))
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

extension Array : ValueEncoderTrait where Element : ValueEncoderTrait, Element == Element.JsonEncoded {
    
    public typealias JsonEncoded = Array< Element.JsonEncoded >
    public typealias JsonEncodeOptions = ArrayEncodeOptions< Element.JsonEncodeOptions >
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        if options.sequence.contains(.nonEmpty) == true && value.isEmpty == true {
            throw CodingError(in: path)
        }
        let result = NSMutableArray(capacity: value.count)
        for index in value.indices {
            do {
                let element = try Element.json(encode: value[index], in: path.appending(.index(index)), with: options.element)
                if let element = element {
                    result.add(element)
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
