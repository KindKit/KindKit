//
//  KindKit
//

import KindCore

public extension Coder {

    struct SemaVersion : IValueDecoder {
        
        public typealias JsonDecoded = KindCore.SemaVersion
        typealias InternalCoder = Coder.String
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            guard let value = JsonDecoded(value) else {
                throw Error.Coding.cast(path)
            }
            return value
        }
        
    }
    
}

extension SemaVersion : IDecoderAlias {
    
    public typealias JsonDecoder = Coder.SemaVersion
    
}
