//
//  KindKit
//

import Foundation

public extension Coder {
    
    struct Model< Coder > {
    }
    
}

extension Coder.Model : IValueDecoder where Coder : IModelDecoder {
    
    public typealias JsonDecoded = Coder.JsonModelDecoded
    
    public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
        return try Coder.decode(.init(path: path, root: value))
    }
    
}

extension Coder.Model : IValueEncoder where Coder : IModelEncoder {
    
    public typealias JsonEncoded = Coder.JsonModelEncoded
    
    public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
        let json = Document(path: path)
        try Coder.encode(value, json: json)
        guard let root = json.root else {
            throw Error.Coding.cast(path)
        }
        return root
    }
    
}
