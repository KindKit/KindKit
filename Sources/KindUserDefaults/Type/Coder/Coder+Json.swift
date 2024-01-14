//
//  KindKit
//

import KindJSON

public extension Coder {
    
    struct Json< JsonModelCoder > {
    }
    
}

extension Coder.Json : IValueDecoder where JsonModelCoder : KindJSON.IModelDecoder {
    
    public static func decode(_ value: IValue) throws -> JsonModelCoder.JsonModelDecoded {
        guard let string = try? Coder.String.decode(value) else {
            throw Error.cast
        }
        guard let json = try? KindJSON.Document(path: .root, string: string) else {
            throw Error.cast
        }
        do {
            return try json.decode(JsonModelCoder.self)
        } catch {
            throw Error.cast
        }
    }

}

extension Coder.Json : IValueEncoder where JsonModelCoder : KindJSON.IModelEncoder {
    
    public static func encode(_ value: JsonModelCoder.JsonModelEncoded) throws -> IValue {
        let json = KindJSON.Document(path: .root)
        do {
            try json.encode(JsonModelCoder.self, value: value)
        } catch {
            throw Error.cast
        }
        guard let string = try json.asString() else {
            throw Error.cast
        }
        return try Coder.String.encode(string)
    }
    
}
