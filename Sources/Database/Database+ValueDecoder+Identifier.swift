//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct Identifier< ValueDecoder : IDatabaseValueDecoder, Kind : IIdentifierKind > : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> KindKit.Identifier< ValueDecoder.DatabaseDecoded, Kind > {
            return .init(try ValueDecoder.decode(value))
        }
        
    }
    
}

extension Identifier : IDatabaseValueDecoderAlias where Raw : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Identifier< Raw.DatabaseValueDecoder, Kind >
    
}
